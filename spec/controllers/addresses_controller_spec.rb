# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AddressesController, type: :controller do
  sign_in_user

  describe 'GET #index' do
    let(:address) { create(:address) }

    it 'renders the index template' do
      get :index, params: { contact_id: address.contact_id }

      expect(response).to render_template(:index)
    end

    it 'assigns all addresses to @addresses' do
      get :index, params: { contact_id: address.contact_id }

      expect(assigns(:addresses)).to eq([address])
    end
  end

  describe 'GET #new' do
    let(:contact) { create(:contact) }

    it 'renders the new template' do
      get :new, params: { contact_id: contact.id }

      expect(response).to render_template(:new)
    end

    it 'assigns a new address to @address' do
      get :new, params: { contact_id: contact.id }

      expect(assigns(:address)).to be_a_new(Address)
    end
  end

  describe 'GET #edit' do
    let(:address) { create(:address) }

    it 'renders the edit template' do
      get :edit, params: { contact_id: address.contact_id, id: address.id }

      expect(response).to render_template(:edit)
    end

    it 'assigns the requested address to @address' do
      get :edit, params: { contact_id: address.contact_id, id: address.id }

      expect(assigns(:address)).to eq(address)
    end
  end

  describe 'GET #show' do
    let(:address) { create(:address) }

    it 'renders the show template' do
      get :show, params: { contact_id: address.contact_id, id: address.id }

      expect(response).to render_template(:show)
    end

    it 'assigns the requested address to @address' do
      get :show, params: { contact_id: address.contact_id, id: address.id }

      expect(assigns(:address)).to eq(address)
    end
  end

  describe 'POST #create' do
    let(:contact) { create(:contact) }
    let(:valid_attributes) do
      {
        zipcode: Faker::Address.zip_code,
        street: Faker::Address.street_name,
        number: Faker::Address.building_number,
        neighborhood: Faker::Address.community,
        city: Faker::Address.city,
        state: Faker::Address.state
      }
    end
    let(:invalid_attributes) do
      {
        zipcode: nil,
        street: Faker::Address.street_name,
        number: Faker::Address.building_number,
        neighborhood: nil,
        city: Faker::Address.city,
        state: Faker::Address.state
      }
    end

    context 'with valid attributes' do
      it 'creates a new address' do
        post :create, params: { contact_id: contact.id, address: valid_attributes }

        expect(Address.count).to eq(1)
      end
    end

    context 'with invalid attributes' do
      it 'does not create a new address' do
        post :create, params: { contact_id: contact.id, address: invalid_attributes }

        expect(assigns(:address).errors.full_messages)
          .to match(["Zipcode can't be blank", "Neighborhood can't be blank"])
      end

      it 're-renders the new template' do
        post :create, params: { contact_id: contact.id, address: invalid_attributes }

        expect(response).to render_template(:new)
      end
    end
  end

  describe 'PATCH #update' do
    let(:address) { create(:address) }
    let(:valid_attributes) do
      {
        zipcode: '12345',
        street: 'New Street',
        number: '123',
        neighborhood: 'New Neighborhood',
        city: 'New City',
        state: 'New State'
      }
    end

    context 'with valid attributes' do
      before do
        patch :update,
              params: { id: address.id, contact_id: address.contact_id, address: valid_attributes }
        address.reload
      end

      it 'updates the address' do
        expect(assigns(:address).zipcode).to eq valid_attributes[:zipcode]
        expect(assigns(:address).street).to eq valid_attributes[:street]
        expect(assigns(:address).number).to eq valid_attributes[:number]
        expect(assigns(:address).neighborhood).to eq valid_attributes[:neighborhood]
        expect(assigns(:address).city).to eq valid_attributes[:city]
        expect(assigns(:address).state).to eq valid_attributes[:state]
      end

      it 'redirects to the address' do
        expect(response).to redirect_to(contact_address_path(address.contact, address))
      end
    end

    context 'with invalid attributes' do
      before do
        patch :update,
              params: { id: address.id, contact_id: address.contact_id, address: { zipcode: nil } }
        address.reload
      end

      it 'does not update the address' do
        expect(address.zipcode).not_to be_nil
      end

      it 're-renders the edit template' do
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:address) { create(:address) }

    it 'deletes the address' do
      expect do
        delete :destroy, params: { id: address.id, contact_id: address.contact_id }
      end.to change(Address, :count).by(-1)
    end

    it 'redirects to the addresses index' do
      delete :destroy, params: { id: address.id, contact_id: address.contact_id }

      expect(response).to redirect_to(contact_addresses_path(address.contact))
    end
  end
end
