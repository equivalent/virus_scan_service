module RequestResponseMocks
  def server_response_list
    stub_request(:get, "http://thisisa.test/wd/virus_scans").
      with(:headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Token abcdefg', 'User-Agent'=>'Ruby'}).
      to_return(:status => 200, :body => yield, :headers => {})
  end

  def server_request_put(options)
    stub_request(:put, "http://thisisa.test/wd/virus_scans/#{options.fetch(:id)}")
      .with(body: %Q{{"virus_scan":{"scan_result":"#{options.fetch(:status)}"}}},
        headers: {
          'Accept'=>'application/json',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'Authorization'=>'Token abcdefg',
          'Content-Type'=>'application/json',
          'User-Agent'=>'Ruby'
        })
      .to_return(:status => 200, :body => yield, :headers => {})
  end
end
