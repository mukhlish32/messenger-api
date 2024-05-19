FactoryBot.define do
  factory :chat_message do
    association :conversation, factory: :conversation
    association :sender, factory: :user
    message { Faker::Lorem.sentence }
    read_at { nil }
  end
end
