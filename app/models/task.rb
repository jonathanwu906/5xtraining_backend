# frozen_string_literal: true

# A task belongs to a user with various validations
class Task < ApplicationRecord
  belongs_to :user
  validates :name, presence: true, length: { maximum: 255 }
  validates :content, presence: true, length: { maximum: 1000 }
  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :priority, presence: true
  validates :status, presence: true
  validates :label, length: { maximum: 30 }, allow_blank: true
  validates :end_time, comparison: { greater_than: :start_time }
  enum :priority, { 高: 0, 中: 1, 低: 2 }
  enum :status, { 未完成: 0, 進行中: 1, 已完成: 2 }
end
