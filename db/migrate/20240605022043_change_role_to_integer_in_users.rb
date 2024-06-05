class ChangeRoleToIntegerInUsers < ActiveRecord::Migration[7.1]
  def change
    change_column :users, :role, 'integer USING CAST(role AS integer)'
  end
end
