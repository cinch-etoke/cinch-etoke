require "cinch/plugins/etoke_framework/formatter"
require "cinch/plugins/etoke_framework/session"
require "cinch/plugins/etoke_framework/session_registry"

RSpec.describe Cinch::Plugins::EtokeFramework::SessionRegistry do
  describe "#find(channel_name)" do
    it 'finds a session for the channel name' do
      session = instance_double(Cinch::Plugins::EtokeFramework::Session)
      sessions = { 'test' => session }

      subject = described_class.new(options: {sessions: sessions})

      expect(subject.find('test')).to eq session
    end

    it 'returns nil if the session does not exist' do
      expect(subject.find('test')).to eq nil
    end
  end
end
