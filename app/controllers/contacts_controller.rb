# frozen_string_literal: true

class ContactsController < ApplicationController
  include Pagy::Backend

  before_action :set_contact, only: %i[show edit update destroy]

  # GET /contacts or /contacts.json
  def index
    @contacts = if params[:full_name].present?
                  Contact.search(params[:full_name], fields: [:full_name])
                else
                  Contact.all
                end
    @pagy, @contacts = pagy(@contacts)
  end

  # GET /contacts/1 or /contacts/1.json
  def show; end

  # GET /contacts/new
  def new
    @contact = Contact.new
    @contact.phones.build
  end

  # GET /contacts/1/edit
  def edit; end

  # POST /contacts or /contacts.json
  # rubocop:disable Metrics/MethodLength
  def create
    @contact = Contact.new(contact_params)
    respond_to do |format|
      if @contact.save
        SendNotificationsForWebhook.new(contact: @contact).notify
        format.html do
          redirect_to contact_url(@contact), notice: 'Contact was successfully created.'
        end
        format.json { render :show, status: :created, location: @contact }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /contacts/1 or /contacts/1.json
  def update
    respond_to do |format|
      if @contact.update(contact_params)
        format.html do
          redirect_to contact_url(@contact), notice: 'Contact was successfully updated.'
        end
        format.json { render :show, status: :ok, location: @contact }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end
  # rubocop:enable Metrics/MethodLength

  # DELETE /contacts/1 or /contacts/1.json
  def destroy
    @contact.destroy

    respond_to do |format|
      format.html { redirect_to contacts_url, notice: 'Contact was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_contact
    @contact = Contact.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def contact_params
    params.require(:contact).permit(:full_name,
                                    :cpf,
                                    :email,
                                    :birthday,
                                    phones_attributes: %i[number whatsapp])
  end
end
