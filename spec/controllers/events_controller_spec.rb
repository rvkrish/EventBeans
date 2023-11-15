require 'rails_helper'

RSpec.describe EventsController, type: :controller do
  let(:user) { FactoryBot.create(:user) }  # Using FactoryBot to create a user
  let(:campaign_id) { ENV["CAMPAIN_ID"] } # Replace with actual campaign ID


  before do
    sign_in user  # Devise test helper for signing in a user
    # Mock IterableApiClient's response
    allow_any_instance_of(IterableApiClient).to receive(:create_event)
      .with(user.email, 'Event A')
      .and_return(response)
  end


  describe "POST #create_event_a" do
    let(:response) { instance_double('Net::HTTPResponse') }

    context 'when response is successful' do
      before { allow(response).to receive(:is_a?).with(Net::HTTPSuccess).and_return(true) }

      it 'sets a success flash and redirects' do
        post :create_event_a
        expect(flash[:notice]).to eq('Event A created successfully!')
        expect(response).to redirect_to(root_path)
      end
    end

    context 'when response is not successful' do
      before { allow(response).to receive(:is_a?).with(Net::HTTPSuccess).and_return(false) }

      it 'sets an alert flash and redirects' do
        post :create_event_a
        expect(flash[:alert]).to eq('Failed to create Event A.')
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'POST #create_event_b' do
  let(:create_response) { instance_double('Net::HTTPResponse') }
  let(:email_response) { instance_double('Net::HTTPResponse') }
    before do
      allow_any_instance_of(IterableApiClient).to receive(:create_event)
        .with(user.email, 'Event B')
        .and_return(create_response)
      allow_any_instance_of(IterableApiClient).to receive(:send_email)
        .with(user.email, campaign_id)
        .and_return(email_response)
    end

    context 'when event creation and email sending are successful' do
      before do
        allow(create_response).to receive(:is_a?).with(Net::HTTPSuccess).and_return(true)
        allow(email_response).to receive(:is_a?).with(Net::HTTPSuccess).and_return(true)
      end

      it 'sets a success flash and redirects' do
        post :create_event_b
        expect(flash[:notice]).to eq('Event B created and email sent successfully!')
        expect(response).to redirect_to(root_path)
      end
    end

    context 'when event creation is successful but email sending fails' do
      before do
        allow(create_response).to receive(:is_a?).with(Net::HTTPSuccess).and_return(true)
        allow(email_response).to receive(:is_a?).with(Net::HTTPSuccess).and_return(false)
      end

      it 'sets an alert flash and redirects' do
        post :create_event_b
        expect(flash[:alert]).to eq('Event B created, but failed to send email.')
        expect(response).to redirect_to(root_path)
      end
    end

    context 'when event creation fails' do
      before do
        allow(create_response).to receive(:is_a?).with(Net::HTTPSuccess).and_return(false)
      end

      it 'sets an alert flash and redirects' do
        post :create_event_b
        expect(flash[:alert]).to eq('Failed to create Event B.')
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
