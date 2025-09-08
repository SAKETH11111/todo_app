class TasksController < ApplicationController
  before_action :set_task, only: %i[show edit update destroy toggle]

  def index
    @tasks = Task.ordered
  end

  def show
  end

  def new
    @task = Task.new
  end

  def edit
  end

  def create
    @task = Task.new(task_params)

    if @task.save
      respond_to do |format|
        format.turbo_stream do
          @tasks = Task.ordered
          render turbo_stream: turbo_stream.update("tasks-list", partial: "tasks/list", locals: { tasks: @tasks })
        end
        format.html { redirect_to tasks_path, notice: "Task was successfully created." }
      end
    else
      respond_to do |format|
        format.turbo_stream { render :new, status: :unprocessable_entity }
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    if @task.update(task_params)
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.update("task_#{@task.id}", partial: "tasks/task_card", locals: { task: @task })
        end
        format.html { redirect_to tasks_path, notice: "Task was successfully updated." }
      end
    else
      respond_to do |format|
        format.turbo_stream { render :edit, status: :unprocessable_entity }
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def toggle
    @task.update(completed: !@task.completed?)
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.update("task_#{@task.id}", partial: "tasks/task_card", locals: { task: @task })
      end
      format.html { redirect_to tasks_path, notice: "Task marked as #{@task.completed? ? 'completed' : 'incomplete'}." }
    end
  end

  def destroy
    @task.destroy
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove("task_#{@task.id}") }
      format.html { redirect_to tasks_path, notice: "Task was successfully deleted." }
    end
  end

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:title, :description, :completed, :due_date, :priority, :position)
  end
end

