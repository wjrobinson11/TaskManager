FactoryBot.define do
  factory :task do
    name { "Task name" }
    description { "Description" }
    price { 10 }
    company_id { 1 }
  end
end