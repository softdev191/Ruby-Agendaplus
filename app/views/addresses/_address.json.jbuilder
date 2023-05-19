# frozen_string_literal: true

json.extract! address, :id, :zipcode, :street, :number, :neighborhood, :city, :state, :contact_id,
              :created_at, :updated_at
json.url address_url(address, format: :json)
