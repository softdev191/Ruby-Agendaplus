# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Contact, type: :model do
  describe 'validations' do
    subject { build(:contact) }
    it { should validate_uniqueness_of(:cpf).ignoring_case_sensitivity }
    it { should validate_uniqueness_of(:email) }
    it { should validate_presence_of(:full_name) }
    it { should validate_presence_of(:cpf) }
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:birthday) }

    context 'when create contact with correct CPF' do
      it 'returns true' do
        contact = build(:contact)

        contact.save

        expect(Contact.count).to eq(1)
      end
    end

    context 'when create contact passing just letters in CPF' do
      it 'raises ActiveRecord::RecordInvalid when CPF is invalid' do
        contact = build(:contact, cpf: 'abcdefghijk')

        expect { contact.save! }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context 'when create contact passing CPF contains mask' do
      it 'returns true' do
        contact = build(:contact, cpf: '111.111.111-11')

        contact.save!

        contact.reload
        expect(contact.cpf).to eq('11111111111')
      end
    end

    context 'when create contact with less than 18 years old' do
      it 'returns message error' do
        contact = build(:contact, birthday: 10.years.ago)

        contact.save

        expect(contact.errors['birthday'].first)
          .to eq('Error! The contact must have between 18 and 100 years old age.')
      end
    end

    context 'when create contact with bigger than 100 years old' do
      it 'returns message error' do
        contact = build(:contact, birthday: 102.years.ago)

        contact.save

        expect(contact.errors['birthday'].first)
          .to eq('Error! The contact must have between 18 and 100 years old age.')
      end
    end
  end

  describe 'associations' do
    it { should have_many(:phones).dependent(:destroy) }
    it { should have_many(:addresses).dependent(:destroy) }
  end
end
