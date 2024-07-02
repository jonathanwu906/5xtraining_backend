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

  def admin?
    role == 'admin'
  end
end
