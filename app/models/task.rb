# frozen_string_literal: true

# A task belongs to a user with various validations
class Task < ApplicationRecord
  paginates_per 5

  belongs_to :user

  validates :name, presence: true, length: { maximum: 255 }
  validates :content, presence: true, length: { maximum: 1000 }
  validates :start_time, presence: true
  validates :end_time, presence: true, comparison: { greater_than: :start_time }
  validates :priority, presence: true
  validates :status, presence: true
  validates :label, length: { maximum: 30 }, allow_blank: true
  enum :priority, { high: 0, medium: 1, low: 2 }
  enum :status, { pending: 0, in_progress: 1, completed: 2 }

  scope :in_processing, -> { where('end_time > ?', Time.current) }
  scope :with_name, ->(name_query) { where('name ILIKE ?', "%#{name_query}%") }
  scope :with_status, ->(status) { where(status:) }
end
