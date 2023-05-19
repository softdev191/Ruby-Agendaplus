# frozen_string_literal: true

class Phone < ApplicationRecord
  before_save :clean_number

  belongs_to :contact

  validates :number, presence: true, uniqueness: true

  private

  def clean_number
    return if number.nil? || number.empty?

    self.number = number.delete('^0-9')
  end
end
