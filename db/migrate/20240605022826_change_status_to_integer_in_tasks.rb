class ChangeStatusToIntegerInTasks < ActiveRecord::Migration[7.1]
  def change
    change_column :tasks, :status, 'integer USING CAST(status AS integer)'
  end
end
