# frozen_string_literal: true

class AddressesController < ApplicationController
  before_action :set_contact
  before_action :set_address, only: %i[show edit update destroy]

  respond_to :html

  def index
    @addresses = Address.all
    respond_with(@contact, @addresses)
  end

  def show
    respond_with(@contact, @address)
  end

  def new
    @address = Address.new
    respond_with(@contact, @address)
  end

  def edit; end

  def create
    @address = Address.new(address_params)
    @address.contact = @contact
    @address.save

    respond_with(@contact, @address)
  end

  def update
    @address.update(address_params)

    respond_with(@contact, @address)
  end

  def destroy
    @address.destroy

    respond_with(@contact, @address)
  end

  private

  def set_address
    @address = Address.find(params[:id])
  end

  def set_contact
    @contact = Contact.find(params[:contact_id])
  end

  def address_params
    params.require(:address).permit(:zipcode,
                                    :street,
                                    :number,
                                    :neighborhood,
                                    :city,
                                    :state,
                                    :country)
  end
end
