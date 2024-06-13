# frozen_string_literal: true

# TaskController handles the CRUD operations for tasks
class TasksController < ApplicationController
  before_action :find_task, only: %i[show edit update destroy]

  def index
    @tasks = Task.all
  end

  def show; end

  def new
    @task = Task.new
  end

  def edit; end

  def create
    # TODO: 之後會改成登入後從 session 取得 user
    user = User.first
    @task = user.tasks.build(task_params)
    if @task.save
      flash[:notice] = I18n.t('tasks.created_successfully')
      redirect_to action: :show, id: @task.id
    else
      flash[:notice] = '任務建立失敗！' # rubocop:disable Rails/I18nLocaleTexts
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @task.update(task_params)
      flash[:notice] = I18n.t('tasks.updated_successfully')
      redirect_to action: :show, id: @task.id
    else
      flash[:notice] = '任務更新失敗！' # rubocop:disable Rails/I18nLocaleTexts
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @task = Task.find(params[:id])
    @task.destroy
    redirect_to root_path, notice: I18n.t('tasks.destroyed_successfully')
  end

  private

  def find_task
    @task = Task.find(params[:id])
  end

  def task_params
    allowed_params = %i[name content start_time end_time priority status label]
    params.require(:task).permit(*allowed_params)
  end
end
