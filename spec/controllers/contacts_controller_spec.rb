# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ContactsController, type: :controller do
  sign_in_user

  describe 'GET #index' do
    it 'returns a success response' do
      get :index

      expect(response).to be_successful
    end

    it 'assigns @contacts' do
      contact = create(:contact)

      get :index

      expect(assigns(:contacts)).to eq([contact])
    end

    context 'when searching by name', search: true do
      it 'return matching contacts' do
        create_list(:contact, 5)
        contact = create(:contact)

        Contact.search_index.refresh

        get :index, params: { full_name: contact.full_name }

        expect(assigns(:contacts)).to include(contact)
      end
    end

    context 'when search and contact not exists' do
      it 'returns an empty array' do
        create_list(:contact, 5)

        get :index, params: { full_name: anything }

        expect(assigns(:contacts).present?).to be_falsey
      end
    end
  end

  describe 'GET #show' do
    let(:contact) { create(:contact) }

    it 'assigns the requested contact to @contact' do
      get :show, params: { id: contact.id }

      expect(assigns(:contact)).to eq(contact)
    end

    it 'renders the :show template' do
      get :show, params: { id: contact.id }

      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    it 'returns a success response' do
      get :new
      expect(response).to be_successful
    end

    it 'assigns a new contact to @contact' do
      get :new
      expect(assigns(:contact)).to be_a_new(Contact)
    end
  end

  describe 'GET #edit' do
    it 'returns a success response' do
      contact = create(:contact)
      get :edit, params: { id: contact.to_param }
      expect(response).to be_successful
    end

    it 'assigns the requested contact to @contact' do
      contact = create(:contact)
      get :edit, params: { id: contact.to_param }
      expect(assigns(:contact)).to eq(contact)
    end
  end

  describe 'POST #create', :vcr do
    let(:valid_attributes) do
      { full_name: 'Bruce Wayne',
        email: 'bruce.wayne@dc.com',
        cpf: '333.333.333-33',
        birthday: 48.years.ago.to_date }
    end

    let(:invalid_attributes) do
      { full_name: 'Bruce Wayne',
        email: 'bruce.wayne@dc.com',
        cpf: nil,
        birthday: 48.years.ago.to_date }
    end

    context 'with valid params' do
      it 'creates a new Contact' do
        post :create, params: { contact: valid_attributes }

        expect(assigns(:contact)[:full_name]).to eq(valid_attributes[:full_name])
        expect(assigns(:contact)[:email]).to eq(valid_attributes[:email])
        expect(assigns(:contact)[:cpf]).to eq('33333333333')
        expect(assigns(:contact)[:birthday]).to eq(valid_attributes[:birthday])
      end

      it 'redirects to the created contact' do
        post :create, params: { contact: valid_attributes }

        expect(response).to redirect_to(Contact.last)
      end
    end

    context 'with valid params and includes phones number' do
      it 'creates a new Contact' do
        phone_list = {
          phones_attributes: [{ number: '(85) 9 9999-9999', whatsapp: true },
                              { number: '(88) 9 8888-8888', whatsapp: false }]
        }

        post :create, params: { contact: valid_attributes.merge(phone_list) }

        phone_numbers_cleaned = phone_list[:phones_attributes]
                                .pluck(:number).map { |number| number.delete('^0-9') }

        expect(assigns(:contact).phones.pluck(:number)).to match(phone_numbers_cleaned)
        expect(assigns(:contact).phones.count).to eq(2)
        expect(assigns(:contact).phones.where(whatsapp: true).count).to eq(1)
      end
    end

    context 'with invalid params' do
      it 'returns message error' do
        post :create, params: { contact: invalid_attributes }

        expect(assigns(:contact).errors.full_messages)
          .to match(["Cpf can't be blank",
                     'Cpf is the wrong length (should be 11 characters)',
                     'Cpf is invalid'])
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
        { birthday: 19.years.ago.to_date }
      end

      it 'updates the requested contact' do
        contact = create(:contact)

        put :update, params: { id: contact.id, contact: new_attributes }

        contact.reload

        expect(contact.birthday).to eq(new_attributes[:birthday])
      end

      it 'redirects to the contact' do
        contact = create(:contact)

        put :update, params: { id: contact.id, contact: new_attributes }

        expect(response).to redirect_to(contact)
      end
    end

    context 'with invalid params' do
      let(:new_invalid_attributes) { { cpf: '12312' } }

      it 'returns a message error' do
        contact = create(:contact)

        put :update, params: { id: contact.id, contact: new_invalid_attributes }

        expect(assigns(:contact).errors.full_messages)
          .to match(['Cpf is the wrong length (should be 11 characters)', 'Cpf is invalid'])
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested contact' do
      contact = create(:contact)

      expect do
        delete :destroy, params: { id: contact.to_param }
      end.to change(Contact, :count).by(-1)
    end

    it 'redirects to the contacts list' do
      contact = create(:contact)

      delete :destroy, params: { id: contact.to_param }

      expect(response).to redirect_to(contacts_url)
    end
  end
end
