class TasksController < ApplicationController
  before_action :set_task, only: %i[show edit update destroy]

  def index
    @tasks = Task.all
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
      redirect_to @task, notice: '成功建立任務！'
    else
      render :new
    end
  end

  def update
    if @task.update(task_params)
      redirect_to @task, notice: '成功更新任務！'
    else
      render :edit
    end
  end

  def destroy
    @task.destroy
    redirect_to tasks_url, notice: '成功刪除任務！'
  end

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:name, :content, :start_time, :end_time, :priority, :status, :label, :user_id)
  end
end
