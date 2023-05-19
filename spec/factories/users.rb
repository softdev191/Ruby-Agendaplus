# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { 'caio@leadster.com.br' }
    password { Devise.friendly_token(16) }
  end
end
