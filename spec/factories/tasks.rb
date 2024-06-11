# frozen_string_literal: true

FactoryBot.define do
  factory :task do
    name { Faker::Lorem.sentence }
    content { Faker::Lorem.paragraph }
    start_time { Time.zone.now }
    end_time { start_time + duration }
    priority { '高' }
    status { '未完成' }

    user

    transient do
      duration { 1.hour }
    end
  end
end
