# frozen_string_literal: true

# TaskController handles the CRUD operations for tasks
class TasksController < ApplicationController
  before_action :find_task, only: %i[show edit update destroy]
  helper_method :sort_order_options, :status_filter_options

  def index
    @tasks = fetch_tasks
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
      flash[:success] = I18n.t('tasks.created_successfully')
      redirect_to action: :show, id: @task.id
    else
      flash[:alert] = I18n.t('tasks.created_failed')
      flash.discard
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @task.update(task_params)
      flash[:success] = I18n.t('tasks.updated_successfully')
      redirect_to action: :show, id: @task.id
    else
      flash[:alert] = I18n.t('tasks.updated_failed')
      flash.discard
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @task.destroy
    flash[:success] = I18n.t('tasks.destroyed_successfully')
    redirect_to root_path
  end

  private

  def fetch_tasks
    tasks = Task.in_processing
                .with_name(params[:name_query])
                .order(params[:sort_order] || 'created_at')
    tasks = tasks.with_status(params[:status]) if params[:status].present?
    tasks.page(params[:page])
  end

  def sort_order_options
    [
      [I18n.t('tasks.sort_options.created_at'), 'created_at'],
      [I18n.t('tasks.sort_options.end_time'), 'end_time'],
      [I18n.t('tasks.sort_options.priority'), 'priority']
    ]
  end

  def status_filter_options
    [
      [I18n.t('tasks.status_options.all'), nil],
      [I18n.t('tasks.status_options.in_progress'), 'in_progress'],
      [I18n.t('tasks.status_options.pending'), 'pending'],
      [I18n.t('tasks.status_options.completed'), 'completed']
    ]
  end

  def find_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(%i[name content start_time end_time priority status label])
  end
end
