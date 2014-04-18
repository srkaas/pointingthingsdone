class UsersController < ApplicationController
  # Set the current points to zero and export the difference to a YAML file.
  # Daily and total points are unaffected.
  # Points can be used in some other application or real life by way of reward.
  def flush
    @user = User.find(params[:id])

    # Generate a file name stamped with the current time.
    # Write the current points in it. (Could be done with YAML gem instead.)
    t = Time.now
    file_path = 'export/points' + t.to_formatted_s(:number) + '.yaml'
    File.open(file_path, 'w') do |f|
      0.upto(PointsData::MAX_WEIGHT) do |i|
        f.write("#{i}: #{@user.current_points[i]}\n")
      end
    end

    # Set the current points to zero.
    0.upto(PointsData::MAX_WEIGHT) do |i|
      @user.current_points[i] = 0
    end

    @user.save

    # Report the action in a message.
    m = Message.create(contents: "Current points set to zero, totals exported to YAML.")

    # Make the browser download the generated file.
    send_file(file_path)
  end
end