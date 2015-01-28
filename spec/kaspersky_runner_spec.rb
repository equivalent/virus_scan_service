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
      .with("avp.com SCAN /tmp/file.png /i4 /fa /RA:#{scan_log}")
      .and_return(nil)
  end

  describe "#call" do
    let(:call) { runner.call }

    context '' do
      before { allow(runner).to receive(:remove_file) } # skip file remove

      it 'downloads the file from net' do
        call
        expect(File.read(runner.scan_file_path))
          .to eq "This-is-a-file-content"
      end
    end

    it 'should remove scanned file' do
      call
      expect(File.exist?(runner.scan_file_path)).to be false
    end

    context 'when no threats detected' do
      before { call }
      it 'sets the result' do
        expect(runner.result).to eq 'Clean'
      end
    end

    context 'when virus detected' do
      before { call }
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
