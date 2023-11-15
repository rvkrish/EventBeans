module IterableMocks
  def stub_valid_iterable_requests
    stub_request(:post, event_url)
      .to_return(status: 200, body: "", headers: {})

    stub_request(:post, email_url)
      .to_return(status: 200, body: "", headers: {})
  end

  def stub_invalid_iterable_requests
    stub_request(:post, event_url)
      .to_return(status: 400, body: "", headers: {})
    stub_request(:post, email_url)
      .to_return(status: 400, body: { message: "email id does not exist" }.to_json, headers: {})
  end

  def stub_invalid_iterable_requests_no_api_key
    stub_request(:post, event_url)
      .to_return(status: 401, body: "", headers: {})
    stub_request(:post, email_url)
      .to_return(status: 401, body: { message: "email id does not exist" }.to_json, headers: {})
  end

  def stub_invalid_iterable_requests_invalid_api_key
    stub_request(:post, event_url)
      .to_return(status: 401, body: "", headers: {})
    stub_request(:post, email_url)
      .to_return(status: 401, body: { message: "email id does not exist" }.to_json, headers: {})
  end

  private

  def event_url
    "#{ENV["BASE_URI"]}#{ENV["EVENT_TRACK_URI"]}"
  end

  def email_url
    "#{ENV["BASE_URI"]}#{ENV["EMAIL_TARGET_URI"]}"
  end
end
