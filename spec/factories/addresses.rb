# frozen_string_literal: true

FactoryBot.define do
  factory :address do
    zipcode { Faker::Address.zip_code }
    street { Faker::Address.street_name }
    number { Faker::Address.building_number }
    neighborhood { Faker::Address.community }
    city { Faker::Address.city }
    state { Faker::Address.state }
    contact { create(:contact) }
  end
end
