require "cinch/plugins/etoke_framework/announcer"
require "cinch/plugins/etoke_framework/session"

RSpec.describe Cinch::Plugins::EtokeFramework::Session do
  describe "#add_toker" do
    it "adds tokers to the session" do
      channel = instance_double(Cinch::Channel, name: '#test', send: nil)
      subject = described_class.new(channel: channel)
      subject.add_toker "angelphish"
      expect(subject.tokers).to include "angelphish"
    end

    it "raises an error if the user is already added to the session" do
      channel = instance_double(Cinch::Channel, name: '#test', send: nil)
      subject = described_class.new(channel: channel)
      subject.add_toker "Horseboy"

      expect {
        subject.add_toker "Horseboy"
      }.to raise_error Cinch::Plugins::EtokeFramework::Session::TokerExistsError
    end
  end

  xdescribe "#start" do
    it "cannot be started by somebody other than the starter" do
      channel = instance_double(Cinch::Channel, name: '#test', send: nil)
      subject = described_class.new(channel: channel)
      subject.initiate("Char")

      expect {
        subject.start("hellcat")
      }.to raise_error Cinch::Plugins::Etoke::Session::IncorrectStarterError
    end

    it "cannot be started once already started" do
      channel = instance_double(Cinch::Channel, name: '#test')
      subject = described_class.new(starter: "Char", channel: channel)
      subject.initiate("Char")
      subject.start("Char")
      subject.start("Char")
    end

    it "cancels all timers currently in progress"
  end

  describe "#force_start" do
    it 'allows anybody to start the session' do

    end

    it "cannot be started once already started" do

    end
  end
end
