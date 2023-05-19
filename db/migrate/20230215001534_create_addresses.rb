# frozen_string_literal: true

class CreateAddresses < ActiveRecord::Migration[7.0]
  def change
    create_table :addresses do |t|
      t.string :zipcode
      t.string :street
      t.string :number
      t.string :neighborhood
      t.string :city
      t.string :state
      t.references :contact, null: false, foreign_key: true

      t.timestamps
    end
  end
end
