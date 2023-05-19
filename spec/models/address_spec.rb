# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Address, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:zipcode) }
    it { should validate_presence_of(:street) }
    it { should validate_presence_of(:neighborhood) }
    it { should validate_presence_of(:city) }
    it { should validate_presence_of(:state) }
  end

  describe 'associations' do
    it { should belong_to(:contact) }
  end
end
