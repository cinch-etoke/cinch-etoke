require 'cinch/plugins/cinch_bridge/timer_starter'

module Cinch
  module Plugins
    module EtokeFramework
      class SessionRegistry
        def initialize(timer_starter: CinchBridge::NullTimerStarter.new, options: {})
          @timer_starter = timer_starter
          @sessions = options[:sessions] || {}
        end

        def create(channel:, starter:)
          @sessions[channel.name] = Session.new(timer_starter: @timer_starter, channel: channel)
          @sessions[channel.name].initiate(starter)
        end

        def find(channel_name)
          @sessions[channel_name]
        end
      end
    end
  end
end
