# frozen_string_literal: true

module TasksHelper # rubocop:disable Style/Documentation
  def sort_options(selected_sort_order)
    options_for_select([
                         [I18n.t('tasks.sort_by_created_at'), 'created_at'],
                         [I18n.t('tasks.sort_by_end_time'), 'end_time']
                       ], selected: selected_sort_order)
  end

  def status_filter_options(selected_status)
    options_for_select([[I18n.t('tasks.all_status'), nil]] + Task.statuses.keys.map do |status|
                                                               [I18n.t("tasks.attributes.status.#{status}"), status]
                                                             end, selected: selected_status)
  end
end
