# frozen_string_literal: true

# TaskController handles the CRUD operations for tasks
class TasksController < ApplicationController
  before_action :find_task, only: %i[show edit update destroy]
  before_action :require_login

  def index
    @sort_order = params[:sort_order] || 'created_at'
    @status = params[:status]
    @name_query = params[:name]

    @tasks = current_user.admin? ? Task.all : current_user.tasks
    @tasks = @tasks.page(params[:page])
    @tasks = search_by_name(@tasks)
    @tasks = filter_by_status(@tasks)
    @tasks = sort_tasks(@tasks)
    @tasks = @tasks.joins(:tags).where(tags: { name: params[:tag] }) if params[:tag].present?
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
      update_tags(@task)
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
      update_tags(@task)
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
    redirect_to tasks_path
  end

  private

  def find_task
    @task = Task.find(params[:id])
  end

  def task_params
    allowed_params = %i[name content start_time end_time priority status tag_names: []]
    params.require(:task).permit(*allowed_params)
  end

  def update_tags(task)
    tag_names = params[:task][:tag_names].reject(&:blank?)
    tags = tag_names.map { |name| Tag.find_or_create_by(name:) }
    task.tags = tags
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
