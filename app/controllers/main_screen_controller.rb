class MainScreenController < ApplicationController
  http_basic_authenticate_with name: 'user', password: 'password'
  MESSAGE_LIMIT = 300
  DAY_START_SECONDS_AFTER_MIDNIGHT = 6 * 60 * 60 # 6am

  # Display the standard screen.
  def display
    # Make sure there's exactly one user. Create one if there isn't one. If somehow we've created additional users, ignore them.
    @user = User.all.empty? ? User.create : User.all.first

    # Reset the user if something went wrong.
    @user.make_empty if @user.bad?

    # Display only tasks that haven't been completed.
    @tasks = Task.all.reject { |q| q.completed }

    # Previous time when the page was loaded, or now if this is the first time.
    @previous_load_time = @user.last_seen || Time.now

    @current_load_time = Time.now
    @user.last_seen = @current_load_time
    @user.save

    # Amount of seconds between current time and when the page was last loaded.
    @load_interval = @current_load_time - @previous_load_time

    # Housekeeping tasks.
    reset_daily_points
    possibly_activate_tasks

    # Sort tasks to be displayed first by whether they're active and then by their description.
    @tasks.sort! do |x, y|
      if x.activated && !y.activated
        -1
      elsif !x.activated && y.activated
        1
      else
        x.description <=> y.description
      end
    end

    # Display the maximum number of messages, or the number that exists if it's less, in reverse order of when they were created.
    limit = [MESSAGE_LIMIT, Message.all.length].min
    @messages = Message.all.reverse[0..limit-1]

    # For the new task form.
    @task = Task.new
  end

  # Activate each task with a probability proportional to how many seconds it's been since the last load, or since it was created.
  def possibly_activate_tasks
    @tasks.each do |task|
      age = Time.new - task.created_at
      task.possibly_activate([@load_interval, age].min)
    end
  end

  # Set the "points today" variable to zero. (To fix: If a task was completed, this should actually happen before that, which it doesn't currently.)
  def reset_daily_points
    # Check whether the last time the page was loaded was on a previous day; if so, set points today to zero and leave a message.
    if @previous_load_time < ((@current_load_time - DAY_START_SECONDS_AFTER_MIDNIGHT).midnight + DAY_START_SECONDS_AFTER_MIDNIGHT)
      0.upto(PointsData::MAX_WEIGHT) { |i| @user.points_today[i] = '0' }
      @user.save
      Message.create(contents: "Daily reset for #{@previous_load_time.to_date}.")
    end
  end
end