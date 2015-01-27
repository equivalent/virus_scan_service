require 'spec_helper'

RSpec.describe VirusScanService::KasperskyRunner do
  let(:runner) { described_class.new('http://thisis.test/download/file.png' ) }

  it "#call" do
    runner
    skip 'implement kaspersky'
  end
end
