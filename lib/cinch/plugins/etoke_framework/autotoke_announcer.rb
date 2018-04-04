require 'cinch/plugins/cinch_bridge/timer_starter'

module Cinch
  module Plugins
    module EtokeFramework
      class AutotokeAnnouncer
        def initialize(channel:, session:, announcer:)
          @session = session
          @channel = channel
          @announcer = announcer
        end

        def two_minute_warning
          message = @announcer.two_minute_warning(tokers: @session.tokers, starter: @session.starter)
          @channel.send message
        end

        def autotoke_warning
          message = @announcer.autotoke_starting(tokers: @session.tokers, starter: @session.starter)
          @channel.send message
        end
      end
    end
  end
end
