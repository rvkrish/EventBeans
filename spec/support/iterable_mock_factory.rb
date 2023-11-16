module IterableMockFactory
  def stub_with_param_status(response_status)
    stub_request(:post, event_url).to_return(self.send(response_status))
    stub_request(:post, email_url).to_return(self.send(response_status))
  end

  def stub_with_custom_status(url, status, body)
    stub_request(:post, url).to_return(status: status, body: body)
  end

  private

  def invalid_api_key_body
    {
      status: 401,
      headers: {},
      body: { msg: "Invalid API key" }.to_json,
    }
  end

  def invalid_parameters
    {
      status: 400,
      headers: {},
      body: { msg: "Invalid parameters" }.to_json,
    }
  end

  def valid_response
    {
      status: 200,
      headers: {},
      body: { msg: "", code: "Success", params: {} }.to_json,
    }
  end

  def event_url
    "#{ENV["BASE_URI"]}#{ENV["EVENT_TRACK_URI"]}"
  end

  def email_url
    "#{ENV["BASE_URI"]}#{ENV["EMAIL_TARGET_URI"]}"
  end
end
