require "net/http"
require "json"

class IterableApiClient
  attr_accessor :uri, :api_key, :event_uri, :email_uri

  def initialize(api_key)
    self.api_key = api_key
    self.event_uri = URI("#{ENV["BASE_URI"]}#{ENV["EVENT_TRACK_URI"]}")
    self.email_uri = URI("#{ENV["BASE_URI"]}#{ENV["EMAIL_TARGET_URI"]}")
  end

  # This methods helps us interact with API and creating the event
  def create_event(user_email, event_type)
    return unless valid_email?(user_email)
    request_to_api(event_uri, { email: user_email, eventName: event_type })
  end

  # This method helps to send the email when event b is clicked.
  def send_email(user_email, campaign_id)
    return unless valid_email?(user_email)
    request_to_api(email_uri, { recipientEmail: user_email, campaignId: campaign_id })
  end

  private

  #This method handle api request
  def request_to_api(uri, body)
    request = Net::HTTP::Post.new(email_uri)
    request["Api-Key"] = api_key
    request.content_type = "application/json"
    request.body = body.to_json
    Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == "https") do |http|
      http.request(request)
    end
  end

  def valid_email?(email)
    email =~ URI::MailTo::EMAIL_REGEXP
  end
end
