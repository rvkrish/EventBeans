# spec/services/iterable_api_client_spec.rb
require 'rails_helper'

describe IterableApiClient do

  # Setup for tests: Creating user and client instances, and defining test data
  let(:user) {  FactoryBot.create(:user) }
  let(:client) { IterableApiClient.new('fake_api_key') }
  let(:event_name) { 'Event A' }
  let(:campaign_id) { ENV['CAMPAIN_ID'] }

  let(:track_event_uri) { "https://api.iterable.com/api/events/track" }
  let(:invalid_email) { nil }
  let(:valid_campaign_id) { '12345' }
  let(:empty_campaign_id) { nil }
  let(:invalid_campaign_id) { 'invalid_id' }

   # Tests for create_event method
  describe '#create_event' do
    context 'when successful' do
      before { stub_valid_iterable_requests }

      it 'creates an event and returns a successful response' do
        response = client.create_event(user.email, event_name)
        expect(response.code).to eq "200"
        expect(WebMock).to have_requested(:post,track_event_uri ).once
      end
    end

    context 'when unsuccessful' do
      before { stub_invalid_iterable_requests }
      it 'fails to create an event and returns an error response' do
        response = client.create_event(user.email, event_name)
        expect(response.code).to eq "500"
      end
    end
  end

 # Testing event name validation
  describe 'validating the event name' do
    before { stub_invalid_iterable_event_name }

    context 'when event name is empty' do

      let(:response_status) { 400 }  # or appropriate status code for this scenario
      let(:response_body) { { error: 'Invalid event name' }.to_json }

      it 'returns an error response' do
        response = client.create_event(user.email, '')
        expect(response.code).to eq('400')
      end
    end

    context 'when event name is invalid' do
      let(:response_status) { 400 }  # adjust based on API's actual behavior
      let(:response_body) { { error: 'Invalid event name' }.to_json }

      it 'returns an error response' do
        response = client.create_event(user.email, 'Invalid Event')
        expect(response.code).to eq('400')
      end
    end
  end

  describe '#create_event' do

    before { stub_valid_iterable_requests }

    context 'when email is valid' do
      it 'sends a request to the API' do
        client.create_event(user.email, event_name)
        expect(WebMock).to have_requested(:post, /events\/track/).once
      end
    end

    context 'when email is invalid' do
      it 'does not send a request to the API' do
        client.create_event(invalid_email, event_name)
        expect(WebMock).not_to have_requested(:post, /events\/track/)
      end
    end

    context 'when empty email is invalid' do
      it 'does not send a request to the API' do
        client.create_event('', event_name)
        expect(WebMock).not_to have_requested(:post, /events\/track/)
      end
    end
  end

  # Tests for send_email method
  describe '#send_email' do

    before do
      stub_request(:post, client.email_uri.to_s).to_return(status: response_status, body: response_body)
    end

    context 'when email sending is successful' do
      let(:response_status) { 200 }
      let(:response_body) { { message: 'Email sent successfully' }.to_json }

      it 'sends an email successfully' do
        response = client.send_email(user.email, campaign_id)
        expect(response.code).to eq('200')
      end
    end

    context 'when email sending fails' do
      let(:response_status) { 500 }
      let(:response_body) { { error: 'Internal Server Error' }.to_json }

      it 'fails to send an email' do
        response = client.send_email(user.email, campaign_id)
        expect(response.code).to eq('500')
      end
    end

    context 'when campaign ID is valid' do
      let(:response_status) { 200 }
      let(:response_body) { { message: 'Success' }.to_json }

      it 'successfully sends an email' do
        response = client.send_email(user.email, valid_campaign_id)
        expect(response.code).to eq('200')
      end
    end

    context 'when campaign ID is invalid' do
      let(:response_status) { 400 }
      let(:response_body) { { error: 'Invalid campaign ID' }.to_json }

      it 'fails to send an email' do
        response = client.send_email(user.email, invalid_campaign_id)
        expect(response.code).to eq('400')
      end
    end
  end
end
