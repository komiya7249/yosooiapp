FactoryBot.define do
  factory :weather do
    association :municipality
    time { "2024-05-25" }
    temperature_max { 25 }
    temperature_min { 15 }
    precipitation_probability { 10 }
    weather_code { "sun" }
    apparent_temperature_max { 25 }
    wear_symbol { "long_sleeve_shirt" }
  end
end
