# frozen_string_literal: true

# Change the type of status from string to integer
class ChangeStatusToIntegerInTasks < ActiveRecord::Migration[7.1]
  def up
    change_column :tasks, :status, :integer
  end

  def down
    change_column :tasks, :status, :string
  end
end
