# frozen_string_literal: true

FactoryBot.define do
  factory :contact do
    full_name { Faker::Name.name_with_middle }
    cpf { Faker::IDNumber.brazilian_citizen_number }
    email { Faker::Internet.email }
    birthday { 20.years.ago.to_date }

    after(:create) do |contact|
      create(:phone, contact:)
    end
  end
end
