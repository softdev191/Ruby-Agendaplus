# frozen_string_literal: true

class SendNotificationsForWebhook
  URL = ENV['WEBHOOK_URL']

  def initialize(contact:)
    @contact = contact
  end

  def notify
    HTTParty.post(URL, options)
  end

  private

  def options
    {
      body: {
        contact: {
          id: @contact.id,
          nome: @contact.full_name,
          email: @contact.email,
          telefone: @contact.hash_of_phones
        }
      }
    }
  end
end
