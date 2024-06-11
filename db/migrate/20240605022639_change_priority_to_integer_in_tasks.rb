# frozen_string_literal: true

# Change the type of priority from string to integer
class ChangePriorityToIntegerInTasks < ActiveRecord::Migration[7.1]
  def up
    change_column :tasks, :priority, :integer
  end

  def down
    change_colukn :tasks, :priority, :string
  end
end
