require 'spec_helper'

class DummyViruscheckRunner
  attr_accessor :url

  def initialize(url)
    @url = url
  end

  def call
  end

  def result
    'Clean'
  end
end

RSpec.describe VirusScanService::Courier do
  let(:courier) {
    described_class.new(token: 'abcdefg', host: 'http://thisisa.test')
  }

  before do
    server_response_list do
      '[{"id":"123","scan_result":"","file_url":"http://thisis.test/download/file.png"}]'
    end

    server_request_put(id: 123, status: 'Clean') do
      '{"id":"123","scan_result":"Clean","file_url":"http://thisis.test/download/file.png"}'
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
