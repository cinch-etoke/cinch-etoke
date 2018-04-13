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

  describe "#start" do
    describe "error handling" do
      it "cannot be started by somebody other than the starter" do
        channel = instance_double(Cinch::Channel, name: '#test', send: nil)
        subject = described_class.new(channel: channel)
        subject.initiate("Char")

        expect {
          subject.start("hellcat")
        }.to raise_error Cinch::Plugins::EtokeFramework::Session::IncorrectStarterError
      end
    end
  end
end
