# frozen_string_literal: true

# A task belongs to a user with various validations
class Task < ApplicationRecord
  belongs_to :user
  has_many :task_tags, dependent: :destroy
  has_many :tags, through: :task_tags
  validates :name, presence: true, length: { maximum: 255 }
  validates :content, presence: true, length: { maximum: 1000 }
  validates :start_time, presence: true
  validates :end_time, presence: true, comparison: { greater_than: :start_time }
  validates :priority, presence: true
  validates :status, presence: true
  validates :label, length: { maximum: 30 }, allow_blank: true
  enum :priority, { high: 0, medium: 1, low: 2 }
  enum :status, { pending: 0, in_progress: 1, completed: 2 }

  scope :search_by_name, ->(name) { where('name ILIKE ?', "%#{name}%") if name.present? }
  scope :filter_by_status, ->(status) { where(status:) if status.present? }

  paginates_per 5
end
