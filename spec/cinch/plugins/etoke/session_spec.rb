require "cinch/plugins/etoke/session"

RSpec.describe Cinch::Plugins::Etoke::Session do
  xit 'immedately starts a barker timer' do
    subject = described_class.new(starter: "Char")
    expect(subject.timers.first.started).to eq true
  end

  describe "#tokers" do
    it "includes the session starter" do
      subject = described_class.new(starter: "Char")
      expect(subject.tokers).to include "Char"
    end
  end

  describe "#add_toker" do
    it "adds tokers to the session" do
      subject = described_class.new(starter: "Char")
      subject.add_toker "angelphish"
      expect(subject.tokers).to include "angelphish"
    end

    it "raises an error if the user is already added to the session" do
      subject = described_class.new(starter: "Char")
      subject.add_toker "Horseboy"

      expect {
        subject.add_toker "Horseboy"
      }.to raise_error Cinch::Plugins::Etoke::Session::TokerExistsError
    end
  end

  # Have this call another class to do the actual output
  xdescribe "#start" do
    it "cannot be started by somebody other than the starter" do
      subject = described_class.new(starter: "Char")
      expect {
        subject.start("hellcat")
      }.to raise_error Cinch::Plugins::Etoke::Session::IncorrectStarterError
    end

    it "cannot be started once already started" do
      subject = described_class.new(starter: "Char")
      subject.start("Char")
      subject.start("Char")
    end
  end

  describe "#force_start" do
    it 'allows anybody to start the session' do

    end

    it "cannot be started once already started" do

    end
  end
end
