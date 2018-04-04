require 'cinch'
require "cinch/plugins/etoke_framework/announcer"
require "cinch/plugins/cinch_bridge/timer_starter"

module Cinch
  module Plugins
    module EtokeFramework
      class Session
        FIRST_ANNOUNCEMENT_AT = 10
        AUTO_TOKE_AT = 20

        attr_reader :tokers, :starter

        def initialize(channel:, options: {}, timer_starter: nil)
          @channel = channel
          @announcer = Announcer.new || options[:announcer]
          @tokers = options[:tokers] || []
          @timers = []
          @timer_starter = timer_starter || CinchBridge::NullTimerStarter.new
        end

        def initiate(starter)
          @starter = starter
          @tokers << @starter

          # TODO: Create a minder class that can do these announcements AND automatically start the toke
          @timers << @timer_starter.set(FIRST_ANNOUNCEMENT_AT) { self.give_two_minute_warning }
          @timers << @timer_starter.set(AUTO_TOKE_AT) { self.give_autotoke_warning }
          @timers << @timer_starter.set(AUTO_TOKE_AT + 20) { self.commence_autotoke }

          @channel.send @announcer.session_started(starter)
        end

        def add_toker(toker_name)
          raise TokerExistsError if @tokers.include? toker_name
          @tokers << toker_name
          @channel.send @announcer.toker_added(toker_name)
        end

        # This method should probably be private but it needs to be triggerable by a Cinch timer
        def give_two_minute_warning
          @channel.send @announcer.two_minute_warning(tokers: @tokers, starter: @starter)
        end

        # This method should probably be private but it needs to be triggerable by a Cinch timer
        def give_autotoke_warning
          @channel.send @announcer.auto_toke_starting(tokers: @tokers, starter: @starter)
        end

        class TokerExistsError < StandardError; end
      end
    end
  end
end
