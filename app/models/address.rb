# frozen_string_literal: true

class Address < ApplicationRecord
  belongs_to :contact

  validates :zipcode, :street, :neighborhood, :city, :state, presence: true
end
