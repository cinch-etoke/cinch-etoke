require 'cinch'
require "cinch/plugins/etoke_framework/announcer"
require "cinch/plugins/etoke_framework/autotoke_announcer"
require "cinch/plugins/cinch_bridge/timer_starter"

module Cinch
  module Plugins
    module EtokeFramework
      class Session
        FIRST_ANNOUNCEMENT_AT = 5
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

          autotoke_announcer = AutotokeAnnouncer.new(channel: @channel, session: self, announcer: @announcer)
          @timers << @timer_starter.set(FIRST_ANNOUNCEMENT_AT) { autotoke_announcer.two_minute_warning }
          @timers << @timer_starter.set(AUTO_TOKE_AT) { autotoke_announcer.autotoke_warning }
          #@timers << @timer_starter.set(AUTO_TOKE_AT + 20) { self.commence_autotoke }

          @channel.send @announcer.session_started(starter)
        end

        def add_toker(toker_name)
          raise TokerExistsError if @tokers.include? toker_name
          @tokers << toker_name
          @channel.send @announcer.toker_added(toker_name)
        end

        class TokerExistsError < StandardError; end
      end
    end
  end
end
