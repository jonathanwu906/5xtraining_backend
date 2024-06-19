# frozen_string_literal: true

# Purpose: This module is responsible for sorting tasks based on the field and order provided.
module TaskSorter
  SORT_OREDERES = %w[asc desc].freeze
  SORT_FIELDS = %w[created_at end_time priority status].freeze

  def self.sort(tasks, field, order)
    return tasks unless SORT_FIELDS.include?(field) && SORT_OREDERES.include?(order)

    tasks.order(field => order.to_sym)
  end
end
