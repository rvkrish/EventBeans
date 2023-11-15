module IterableMocks

  def stub_valid_iterable_requests
    stub_request(:post, "https://api.iterable.com/api/events/track")
      .to_return(status: 200, body: "", headers: {})

    stub_request(:post, "https://api.iterable.com/api/email/target")
      .to_return(status: 200, body: "", headers: {})
  end

  def stub_invalid_iterable_requests
    stub_request(:post, "https://api.iterable.com/api/events/track")
    .to_return(status: 500, body: "", headers: {})
    stub_request(:post, "https://api.iterable.com/api/email/target")
      .to_return(status: 500, body: { message: 'email id does not exist' }.to_json, headers: {})
  end
  def stub_invalid_iterable_event_name
    stub_request(:post, "https://api.iterable.com/api/events/track")
    .to_return(status: 400, body: "", headers: {})
    stub_request(:post, "https://api.iterable.com/api/email/target")
      .to_return(status: 400, body: { message: 'email id does not exist' }.to_json, headers: {})
  end


end
