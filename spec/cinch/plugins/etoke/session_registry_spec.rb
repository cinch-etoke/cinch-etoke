require "cinch/plugins/etoke_framework/formatter"
require "cinch/plugins/etoke_framework/session"
require "cinch/plugins/etoke_framework/session_registry"

RSpec.describe Cinch::Plugins::EtokeFramework::SessionRegistry do
  describe "#create" do
    it 'raises an error if a channel already has a session' do
      channel = instance_double(Cinch::Channel, name: '#test', send: nil)
      subject.create(channel: channel, starter: 'Rob')
      expect {
        subject.create(channel: channel, starter: 'Rob')
      }.to raise_error Cinch::Plugins::EtokeFramework::SessionRegistry::SessionExistsForChannelError
    end

    it 'creates a new session if the existing session is finished' do

    end
  end

  describe "#find(channel_name)" do
    it 'finds a session for the channel name' do
      session = instance_double(Cinch::Plugins::EtokeFramework::Session)
      sessions = { 'test' => session }

      subject = described_class.new(options: {sessions: sessions})

      expect(subject.find('test')).to eq session
    end

    it 'raises an error if the session does not exist' do
      expect {
        subject.find('test')
      }.to raise_error Cinch::Plugins::EtokeFramework::SessionRegistry::SessionNotFoundError
    end
    it 'does not return finished sessions' # ???
  end
end
