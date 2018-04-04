require 'cinch'
require 'cinch/plugins/etoke_framework/autotoke_announcer'

RSpec.describe Cinch::Plugins::EtokeFramework::AutotokeAnnouncer do
  describe "#two_minute_warning" do
    it 'Announces to the channel that a two minute warning has occured' do
      channel = instance_double(Cinch::Channel)
      session = double(Cinch::Plugins::EtokeFramework::Session, tokers: ["Geordi"], starter: "Data")
      announcer = double(Cinch::Plugins::EtokeFramework::Announcer)

      expect(announcer).to receive(:two_minute_warning).with(tokers: ["Geordi"], starter: "Data").and_return("Message")
      expect(channel).to receive(:send).with("Message")

      subject = described_class.new(channel: channel, session: session, announcer: announcer)
      subject.two_minute_warning
    end
  end

  describe "#autotoke_warning" do
    it 'Announces to the channel that the auto-toke is about to begin' do
      channel = instance_double(Cinch::Channel)
      session = double(Cinch::Plugins::EtokeFramework::Session, tokers: ["Geordi"], starter: "Data")
      announcer = double(Cinch::Plugins::EtokeFramework::Announcer)

      expect(announcer).to receive(:autotoke_starting).with(tokers: ["Geordi"], starter: "Data").and_return("Message")
      expect(channel).to receive(:send).with("Message")

      subject = described_class.new(channel: channel, session: session, announcer: announcer)
      subject.autotoke_warning
    end
  end
end
