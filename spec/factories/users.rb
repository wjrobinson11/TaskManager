FactoryBot.define do
  factory :super_admin do
    email { "admin@serviceshift.com" }
    password { "admin1234" }
  end

  factory :task_admin do
    email { "task@billygo.com" }
    password { "task1234" }
  end
end