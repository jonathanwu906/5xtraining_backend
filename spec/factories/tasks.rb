FactoryBot.define do
  factory :task do
    name { Faker::Lorem.sentence }
    content { Faker::Lorem.paragraph }
    start_time { Time.now }
    end_time { Time.now + 1.hour }
    priority { "高" }
    status { "未完成" }
    association :user
  end
end
