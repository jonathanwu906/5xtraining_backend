# frozen_string_literal: true

# TaskController handles the CRUD operations for tasks
class TasksController < ApplicationController
  before_action :find_task, only: %i[show edit update destroy]
  before_action :set_sort_options, only: :index

  def index
    @tasks = TaskSorter.sort(Task.all, @sort_order, @sort_direction)
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
    @task.destroy
    redirect_to root_path, notice: I18n.t('tasks.destroyed_successfully')
  end

  private

  def set_sort_options
    @sort_order = params[:sort_order] || 'created_at'
    @sort_direction = params[:sort_direction] || 'asc'
    @sort_order_options = sort_order_options
    @sort_direction_options = sort_direction_options
  end

  def sort_order_options
    {
      I18n.t('tasks.sort_options.created_at') => 'created_at',
      I18n.t('tasks.sort_options.end_time') => 'end_time',
      I18n.t('tasks.sort_options.priority') => 'priority',
      I18n.t('tasks.sort_options.status') => 'status'
    }
  end

  def sort_direction_options
    {
      I18n.t('tasks.sort_directions.asc') => 'asc',
      I18n.t('tasks.sort_directions.desc') => 'desc'
    }
  end

  def find_task
    @task = Task.find(params[:id])
  end

  def task_params
    allowed_params = %i[name content start_time end_time priority status label]
    params.require(:task).permit(*allowed_params)
  end
end
