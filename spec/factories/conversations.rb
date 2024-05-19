FactoryBot.define do
  factory :conversation do
    association :user, factory: :user
    association :with_user, factory: :user
  end
end
