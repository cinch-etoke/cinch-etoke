require 'cinch'
require "cinch/plugins/etoke_framework/announcer"
require "cinch/plugins/etoke_framework/etoke_performer"
require "cinch/plugins/cinch_bridge/timer_starter"

module Cinch
  module Plugins
    module EtokeFramework
      class Session
        FIRST_ANNOUNCEMENT_AT = 5 # seconds
        AUTO_TOKE_WARNING = 20 # seconds
        AUTO_TOKE_STARTS = 25 # seconds

        attr_reader :tokers, :starter

        def initialize(registry: nil, channel:, options: {}, timer_starter: nil)
          @registry = registry
          @channel = channel
          @announcer = Announcer.new || options[:announcer]
          @tokers = options[:tokers] || []
          @timers = []
          @timer_starter = timer_starter || CinchBridge::NullTimerStarter.new
        end

        def initiate(starter)
          @starter = starter
          @tokers << @starter

          @timers << @timer_starter.set(FIRST_ANNOUNCEMENT_AT) { two_minute_warning }
          @timers << @timer_starter.set(AUTO_TOKE_WARNING) { autotoke_warning }
          @timers << @timer_starter.set(AUTO_TOKE_STARTS) { force_start }

          @channel.send @announcer.session_started(starter)
        end

        def add_toker(toker_name)
          return if @started
          raise TokerExistsError if @tokers.include? toker_name
          @tokers << toker_name
          @channel.send @announcer.toker_added(toker_name)
        end

        def start(starting_toker)
          raise IncorrectStarterError if starting_toker != starter
          force_start
        end

        def force_start
          return if @started; @started = true
          @timers.each { |t| t.stop }
          @channel.send @announcer.toke_starting(tokers: tokers, starter: starter)
          EtokePerformer.new(
            registry: @registry,
            timer_starter: @timer_starter,
            channel: @channel,
            announcer: @announcer
          ).perform
        end

        private def two_minute_warning
          message = @announcer.two_minute_warning(tokers: tokers, starter: starter)
          @channel.send message
        end

        private def autotoke_warning
          message = @announcer.autotoke_starting(tokers: tokers, starter: starter)
          @channel.send message
        end

        class TokerExistsError < StandardError; end
        class IncorrectStarterError < StandardError; end
      end
    end
  end
end
