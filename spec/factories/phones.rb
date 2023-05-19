# frozen_string_literal: true

FactoryBot.define do
  factory :phone do
    number { Faker::PhoneNumber.phone_number }
    whatsapp { [false, true].sample }

    trait :with_contact do
      contact { create(:contact) }
    end
  end
end
