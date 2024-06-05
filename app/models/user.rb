class User < ApplicationRecord
  has_many :tasks
  enum :role, { general: 0, admin: 1}
end
