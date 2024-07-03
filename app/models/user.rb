# frozen_string_literal: true

# Users have many tasks, which are destroyed if the user is deleted
class User < ApplicationRecord
  has_secure_password
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :tasks, dependent: :destroy
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true

  enum role: { user: 0, admin: 1 }

  before_destroy :check_last_admin

  private

  def check_last_admin
    return unless User.admin.count == 1

    errors.add(:base, '不能刪除最後一位管理員')
    throw :abort
  end
end
