# frozen_string_literal: true

# TaskController handles the CRUD operations for tasks
class TasksController < ApplicationController
  before_action :find_task, only: %i[show edit update destroy]
  before_action :require_login

  def index
    @sort_order = params[:sort_order] || 'created_at'
    @status = params[:status]
    @name_query = params[:name]

    @tasks = current_user.tasks.page params[:page]
    @tasks = search_by_name(@tasks)
    @tasks = filter_by_status(@tasks)
    @tasks = sort_tasks(@tasks)
  end

  def show; end

  def new
    @task = Task.new
  end

  def edit; end

  def create
    # TODO: 之後會改成登入後從 session 取得 user
    @task = current_user.tasks.build(task_params)
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
    @task = Task.find(params[:id])
    @task.destroy
    flash[:success] = I18n.t('tasks.destroyed_successfully')
    redirect_to root_path
  end

  private

  def find_task
    @task = Task.find(params[:id])
  end

  def task_params
    allowed_params = %i[name content start_time end_time priority status label]
    params.require(:task).permit(*allowed_params)
  end

  def sort_tasks(tasks)
    tasks.order(@sort_order => :asc)
  end

  def search_by_name(tasks)
    @name_query.present? ? tasks.where('name ILIKE ?', "%#{@name_query}%") : tasks
  end

  def filter_by_status(tasks)
    @status.present? ? tasks.where(status: @status) : tasks
  end
end
