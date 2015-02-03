require 'spec_helper'

RSpec.describe VirusScanService::KasperskyRunner::LinuxExecutor do
  subject { described_class.new  }

  let(:desired_cmd) {
    'sudo ' +
    '/opt/kaspersky/kes4lwks/bin/kes4lwks-control ' +
    '--scan-file /tmp/scan_file >> /tmp/bar.log'
  }

  describe '#scan' do
    it 'should exectute correct command' do
      expect(subject)
        .to receive(:system)
        .with(*desired_cmd.split(' '))

      subject.scan(Pathname.new('/tmp').join('scan_file'), Pathname.new('/tmp').join('bar.log'))
    end
  end
end
