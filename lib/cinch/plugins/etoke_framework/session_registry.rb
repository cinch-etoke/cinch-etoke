require 'cinch/plugins/cinch_bridge/timer_starter'

module Cinch
  module Plugins
    module EtokeFramework
      class SessionRegistry
        def initialize(timer_starter: CinchBridge::NullTimerStarter.new)
          @timer_starter = timer_starter
          @sessions = {}
        end

        def create_session(channel:, starter:)
          raise SessionExistsError if @sessions.keys.include? channel.name
          @sessions[channel.name] = Session.new(timer_starter: @timer_starter, channel: channel)
          @sessions[channel.name].initiate(starter)
        end

        class SessionExistsError < StandardError; end
      end
    end
  end
end
