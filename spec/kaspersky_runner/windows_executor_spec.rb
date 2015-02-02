require 'spec_helper'

RSpec.describe VirusScanService::KasperskyRunner::WindowsExecutor do
  subject { described_class.new  }

  let(:desired_cmd) {
    "avp.com SCAN /tmp/scan_file /i4 /fa /RA:/tmp/bar.log"
  }

  describe '#scan' do
    it 'should exectute correct command' do
      expect(subject)
        .to receive(:system)
        .with(desired_cmd)

      subject.scan(Pathname.new('/tmp').join('scan_file'), Pathname.new('/tmp').join('bar.log'))
    end
  end
end
