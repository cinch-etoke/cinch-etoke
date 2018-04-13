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
          raise SessionExistsForChannelError if @sessions.keys.include? channel.name
          @sessions[channel.name] = Session.new(registry: self, timer_starter: @timer_starter, channel: channel)
          @sessions[channel.name].initiate(starter)
        end

        def find(channel_name)
          raise SessionNotFoundError unless @sessions.keys.include? channel_name
          @sessions[channel_name]
        end

        def remove(channel_name)
          @sessions.delete(channel_name)
        end

        class SessionExistsForChannelError < StandardError; end
        class SessionNotFoundError < StandardError; end
      end
    end
  end
end
