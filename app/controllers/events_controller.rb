class EventsController < ApplicationController

  # Ensures user is authenticated before any action method is called
  before_action :authenticate_user!

  def index; end

  def create_event_a
    # Calls API to create 'Event A' with the current user's email
    response = iterable_api_client.create_event(current_user.email, "Event A")
    if response.is_a?(Net::HTTPSuccess)
      flash[:notice] = "Event A created successfully!"
    else
      flash[:alert] = "Failed to create Event A."
    end
    redirect_to root_path
  end

  def create_event_b

    # Calls API to create 'Event B' with the current user's email
    create_response = iterable_api_client.create_event(current_user.email, "Event B")
    if create_response.is_a?(Net::HTTPSuccess)
      # If Event B is created successfully, it then tries to send an email
      email_response = iterable_api_client.send_email(current_user.email, ENV["CAMPAIN_ID"]) # Replace `your_campaign_id` with actual ID
      if email_response.is_a?(Net::HTTPSuccess)
        flash[:notice] = "Event B created and email sent successfully!"
      else
        flash[:alert] = "Event B created, but failed to send email."
      end
    else
      flash[:alert] = "Failed to create Event B."
    end
    redirect_to root_path  # Update with your desired path
  end

  private

  def iterable_api_client
    @iterable_api_client ||= IterableApiClient.new(ENV["ITERABLE_API_KEY"])
  end
end
