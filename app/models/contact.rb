# frozen_string_literal: true

require 'elasticsearch/model'

class Contact < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  searchkick

  MIN_VALID_AGE = 18.years
  MAX_VALID_AGE = 100.years

  before_validation :clean_cpf

  validates :cpf, :email, uniqueness: true
  validates :email, :cpf, :full_name, :birthday, presence: true
  validates :cpf, length: { is: 11 }, format: { with: /\A\d{11}\z/ }
  validate :birthday_is_valid?, if: proc { |attr| attr.birthday }

  has_many :phones, dependent: :destroy
  accepts_nested_attributes_for :phones
  has_many :addresses, dependent: :destroy

  def hash_of_phones
    phones.map { |phone| { number: phone.number, whatsapp: phone.whatsapp } }
  end

  private

  def birthday_is_valid?
    return if (age >= MIN_VALID_AGE) && (age <= MAX_VALID_AGE)

    errors.add(:birthday, 'Error! The contact must have between 18 and 100 years old age.')
  end

  def age
    ((Date.current - birthday) / 365.25).to_i.years
  end

  def clean_cpf
    return if cpf.nil? || cpf.empty?

    self.cpf = cpf.delete('^0-9')
  end
end
