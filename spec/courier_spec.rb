require 'spec_helper'

RSpec.describe VirusScanService::Courier do
  include RequestResponseMocks

  let(:courier) {
    described_class
      .new(token: 'abcdefg', host: 'http://thisisa.test')
      .tap { |c| c.logger = Struct::NullLogger.new }
  }

  before do
    server_response_list do
      '{"data":[{"id":"123","scan_result":"","file_url":"http://thisis.test/download/file.png"}]}'
    end

    server_request_put(id: 123, status: 'Clean') do
      '{"data":{"id":"123","scan_result":"Clean","file_url":"http://thisis.test/download/file.png"}}'
    end
  end

  it do
    expect(DummyViruscheckRunner)
      .to receive(:new)
      .with('http://thisis.test/download/file.png')
      .once
      .and_call_original

    courier.call do |file_url|
      casp = DummyViruscheckRunner.new(file_url)
      casp.call
      casp.result
    end
  end
end
