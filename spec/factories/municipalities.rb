FactoryBot.define do
  factory :municipality do
    sequence(:name) { |n| "Municipality #{n}" }
    latitude { 35.633635 }
    longitude { 139.711713 }
  end
end
