# frozen_string_literal: true

# Create Tasks table
class CreateTasks < ActiveRecord::Migration[7.1]
  def change
    create_table :tasks do |t|
      t.string :name
      t.text :content
      t.datetime :start_time
      t.datetime :end_time
      t.string :priority
      t.string :status
      t.string :label
      t.references :user, null: false, foreign_key: true
      t.timestamps
    end
  end
end
