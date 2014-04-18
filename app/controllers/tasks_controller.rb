class TasksController < ApplicationController
  # Runs when a task is completed with its complete button.
  def complete
    # Set the selected task to completed.
    @task = Task.find(params[:id])
    @task.completed = true
    @task.save

    # Pick the first user, as we did in the main screen controller.
    @user = User.all.first

    # If it was active, award the relevant type of point and leave a message.
    if @task.activated
      @user.points_today[@task.weight] = 
        @user.points_today[@task.weight].to_i + 1
      @user.total_points[@task.weight] =
        @user.total_points[@task.weight].to_i + 1
      @user.current_points[@task.weight] =
        @user.current_points[@task.weight].to_i + 1
      @user.save

      Message.create(
        contents: "Completed task: \
          #{@task.description}. Received \
          <span class='pointstextspan points#{@task.weight}'>\
          #{PointsData::POINT_TYPE_FOR_WEIGHT[@task.weight].capitalize}\
          Point</span>."
        )
    else
      Message.create(contents: "Completed task: #{@task.description}. \
        No points received: task was not active.")
    end

    redirect_to root_path
  end

  # Runs when a task is deleted with its delete button.
  def destroy
    Task.find(params[:id]).destroy

    redirect_to root_path
  end

  # Runs when a task is created with the task creation form.
  def create
    @task = Task.new(post_params)
    @task.activated = false
    @task.completed = false
    @task.save

    redirect_to root_path
  end

  # Runs when a task is repeated with its repeat button.
  def repeat
    # Create a new task with the same parameters as the selected task, but inactive and uncompleted.
    @old_task = Task.find(params[:id])
    @task = Task.create(
      activated: false,
      completed: false,
      description: @old_task.description,
      urgency: @old_task.urgency,
      weight: @old_task.weight
    )

    # Complete the selected task.
    redirect_to complete_task_path(@old_task.id)
  end

  def post_params
    params.require(:task).permit(:description, :weight, :urgency)
  end
end
