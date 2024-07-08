# frozen_string_literal: true

FactoryBot.define do
  factory :task do
    name { Faker::Lorem.sentence }
    content { Faker::Lorem.paragraph }
    start_time { Time.zone.now }
    end_time { start_time + duration }
    priority { %w[low medium high].sample }
    status { %w[in_progress pending completed].sample }
    label { Faker::Lorem.word }

    user

    transient do
      duration { 1.hour }
    end

    trait :pending do
      status { 'pending' }
    end

    trait :in_progress do
      status { 'in_progress' }
    end

    trait :completed do
      status { 'completed' }
    end

    trait :high_priority do
      priority { 'high' }
    end

    trait :medium_priority do
      priority { 'medium' }
    end

    trait :low_priority do
      priority { 'low' }
    end
  end
end
