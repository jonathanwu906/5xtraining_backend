# frozen_string_literal: true

# Add constraints to the tasks table
class AddConstraintsToTasks < ActiveRecord::Migration[7.1]
  def change
    change_column_null :tasks, :name, false
    change_column_null :tasks, :content, false
    change_column_null :tasks, :start_time, false
    change_column_null :tasks, :end_time, false
    change_column_null :tasks, :priority, false
    change_column_null :tasks, :status, false

    add_check_constraint :tasks, 'length of name <= 255', name: 'name_length_check'
    add_check_constraint :tasks, 'length of content <= 1000', name: 'content_length_check'
    add_check_constraint :tasks, 'length of label <= 30', name: 'label_length_check'
  end
end
