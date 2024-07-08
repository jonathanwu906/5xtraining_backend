# frozen_string_literal: true

# Add index to tasks name and status
class AddIndexToTasksNameAndStatus < ActiveRecord::Migration[7.1]
  def change
    add_index :tasks, :name
    add_index :tasks, :status
  end
end
