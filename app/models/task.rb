class Task < ApplicationRecord
  belongs_to :user
  validates :name, presence: true, length: { maximum: 255 }
  validates :content, presence: true, length: { maximum: 1000 }
  validates :start_time, presence: true
  validates :end_time, presence: true, comparison: { greater_than: :start_time }
  validates :priority, presence: true
  validates :status, presence: true
  validates :label, length: { maximum: 30 }, allow_blank: true
  enum :priority, { high: 0, medium: 1, low: 2}
  enum :status, { pending: 0, in_progress: 1, completed: 2}
end
