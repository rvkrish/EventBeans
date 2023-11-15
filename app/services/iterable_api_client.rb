require "net/http"
require "json"

class IterableApiClient
  attr_accessor :uri, :api_key, :event_uri, :email_uri

  def initialize(api_key)
    self.api_key = api_key
    self.event_uri = URI("#{ENV["BASE_URI"]}#{ENV["EVENT_TRACK_URI"]}")
    self.email_uri = URI("#{ENV["BASE_URI"]}#{ENV["EVENT_TARGET_URI"]}")
  end

  def create_event(user_email, event_type)
    return unless valid_email?(user_email)

    request = Net::HTTP::Post.new(event_uri)
    request["Api-Key"] = api_key
    request.content_type = "application/json"
    request.body = {
      email: user_email, eventName: event_type,
    }.to_json
    Net::HTTP.start(event_uri.hostname, event_uri.port, use_ssl: event_uri.scheme == "https") do |http|
      http.request(request)
    end
  end

  def send_email(user_email, campaign_id)
    return unless valid_email?(user_email)

    request = Net::HTTP::Post.new(email_uri)
    request["Api-Key"] = api_key
    request.content_type = "application/json"
    request.body = {
      recipientEmail: user_email, campaignId: campaign_id,
    }.to_json

    Net::HTTP.start(email_uri.hostname, email_uri.port, use_ssl: email_uri.scheme == "https") do |http|
      http.request(request)
    end
  end

  private

  def valid_email?(email)
    email =~ URI::MailTo::EMAIL_REGEXP
  end
end
