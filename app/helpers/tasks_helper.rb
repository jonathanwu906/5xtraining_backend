# frozen_string_literal: true

module TasksHelper # rubocop:disable Style/Documentation
  def sort_options(selected_sort_order)
    options_for_select([
                         [I18n.t('tasks.sort_by_created_at'), 'created_at'],
                         [I18n.t('tasks.sort_by_end_time'), 'end_time']
                       ], selected: selected_sort_order)
  end
end
