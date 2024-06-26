# frozen_string_literal: true

# Users have many tasks, which are destroyed if the user is deleted
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :tasks, dependent: :destroy
end
