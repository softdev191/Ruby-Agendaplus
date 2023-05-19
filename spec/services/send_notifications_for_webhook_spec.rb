# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SendNotificationsForWebhook do
  describe 'notify' do
    context 'receive contact informations and send for webhook', :vcr do
      it 'returns true' do
        send_notification = SendNotificationsForWebhook.new(contact: create(:contact))

        result = send_notification.notify

        expect(result.response.code).to eq('200')
      end
    end
  end
end
