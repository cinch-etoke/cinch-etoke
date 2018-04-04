require "cinch/plugins/etoke_framework/formatter"
require "cinch/plugins/etoke_framework/session"
require "cinch/plugins/etoke_framework/session_registry"

RSpec.describe Cinch::Plugins::EtokeFramework::SessionRegistry do
  describe "#create_session" do
    it 'raises an error if a channel already has a session' do
      channel = instance_double(Cinch::Channel, name: '#test', send: nil)
      subject.create_session(channel: channel, starter: 'Rob')
      expect {
        subject.create_session(channel: channel, starter: 'Rob')
      }.to raise_error Cinch::Plugins::EtokeFramework::SessionRegistry::SessionExistsError
    end

    it 'creates a new session if the existing session is finished' do

    end
  end

  describe "#find(channel_name)" do
    it 'finds a session for the channel name'
    it 'does not return finished sessions' # ???
  end
end
