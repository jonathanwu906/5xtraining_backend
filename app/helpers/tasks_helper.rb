# frozen_string_literal: true

module TasksHelper # rubocop:disable Style/Documentation
  def sort_order_options
    {
      t('tasks.sort_options.created_at') => 'created_at',
      t('tasks.sort_options.end_time') => 'end_time',
      t('tasks.sort_options.priority') => 'priority',
      t('tasks.sort_options.status') => 'status'
    }
  end

  def sort_direction_options
    {
      t('tasks.sort_directions.asc') => 'asc',
      t('tasks.sort_directions.desc') => 'desc'
    }
  end
end
