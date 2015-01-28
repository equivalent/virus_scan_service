require 'spec_helper'
require 'fileutils'

RSpec.describe VirusScanService::KasperskyRunner do
  let(:runner) {
    described_class
      .new('http://thisis.test/download/file.png')
      .tap { |runner| runner.scan_log_path = scan_log }
  }

  let(:scan_log) {
    spec_root
      .join('fixtures')
      .join('virus_result_clean.log')
  }

  before do
    stub_request(:get, "http://thisis.test/download/file.png")
      .with(:headers => {
        'Accept'=>'*/*',
        'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'User-Agent'=>'Ruby'
      })
      .to_return(:status => 200, :body => "This-is-a-file-content", :headers => {})
  end

  before do
    allow(runner)
      .to receive(:system)
      .with("avp.com SCAN tmp/file.png /i4 /fa /RA:#{scan_log}")
      .and_return(nil)
  end

  after do
    FileUtils.rm_r(runner.scan_file_path)
  end

  describe "#call" do
    let(:runner_autorun) { true }
    before { runner.call if runner_autorun}

    it 'downloads the file from net' do
      expect(File.read(runner.scan_file_path))
        .to eq "This-is-a-file-content"
    end

    context 'when no threats detected' do
      it 'sets the result' do
        expect(runner.result).to eq 'Clean'
      end
    end

    context 'when virus detected' do
      let(:scan_log) {
        spec_root
          .join('fixtures')
          .join('virus_result_threat.log')
      }

      it 'sets the result' do
        expect(runner.result).to eq 'VirusInfected'
      end
    end

    context 'when log has error' do
      let(:runner_autorun) { false }

      let(:scan_log) {
        spec_root
          .join('fixtures')
          .join('virus_result_error.log')
      }

      it 'sets the result' do
        expect { runner.call }
          .to raise_error(VirusScanService::KasperskyRunner::ScanLogParseError)
      end
    end
  end
end
