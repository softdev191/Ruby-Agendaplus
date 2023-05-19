# frozen_string_literal: true

class CreateContacts < ActiveRecord::Migration[7.0]
  def change
    create_table :contacts do |t|
      t.string :full_name
      t.string :cpf
      t.string :email
      t.date :birthday

      t.timestamps
    end

    add_index :contacts, :email, unique: true
    add_index :contacts, :cpf, unique: true
  end
end
