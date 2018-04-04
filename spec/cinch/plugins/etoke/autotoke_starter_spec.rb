require 'cinch'
require 'cinch/plugins/etoke_framework/session'
require 'cinch/plugins/etoke_framework/autotoke_starter'

RSpec.describe Cinch::Plugins::EtokeFramework::AutotokeStarter do
  describe "#auto_toke" do
    it "tells the session it is minding to start a toke" do
      session = double(Cinch::Plugins::EtokeFramework::Session)
      expect(session).to receive(:start)
      described_class.new(session).auto_toke
    end
  end
end
