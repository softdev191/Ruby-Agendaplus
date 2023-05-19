# frozen_string_literal: true

FactoryBot.create(:user, email: Faker::Internet.email)

FactoryBot.create_list(:contact, 50)
