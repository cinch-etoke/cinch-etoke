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

        def initialize(channel:, options: {}, timer_starter: nil)
          @channel = channel
          @announcer = Announcer.new || options[:announcer]
          @tokers = options[:tokers] || []
          @announcement_timers = []
          @timer_starter = timer_starter || CinchBridge::NullTimerStarter.new
          @state = :not_started # :not_started -> :started -> :finished
        end

        def initiate(starter)
          @starter = starter
          @tokers << @starter

          @announcement_timers << @timer_starter.set(FIRST_ANNOUNCEMENT_AT) { @channel.send @announcer.two_minute_warning(tokers: tokers, starter: starter) }
          @announcement_timers << @timer_starter.set(AUTO_TOKE_WARNING) { @channel.send @announcer.autotoke_starting(tokers: tokers, starter: starter) }
          @autotoke_timer = @timer_starter.set(AUTO_TOKE_STARTS) { perform_initial_etoke }

          @channel.send @announcer.session_started(starter)
        end

        def add_toker(toker_name)
          return unless @state == :not_started
          return if @tokers.include? toker_name
          @tokers << toker_name
          @channel.send @announcer.toker_added(toker_name)
        end

        def start
          return unless @state == :not_started
          @autotoke_timer.stop
          perform_initial_etoke
        end

        def finish
          @state = :finished
        end

        def finished?
          @state == :finished
        end

        def eligible_for_retoke?
          return false if @state != :finished
          @started_at >= (Time.now - RETOKE_TIME_LIMIT)
        end

        def retoke
          @channel.send @announcer.retoke_banner
          perform_etoke
        end

        private def perform_initial_etoke
          @state = :started
          @started_at = Time.now
          @announcement_timers.each { |t| t.stop }
          perform_etoke
        end

        private def perform_etoke
          @channel.send @announcer.toke_starting(tokers: tokers, starter: starter)
          EtokePerformer.new(
            session: self,
            timer_starter: @timer_starter,
            channel: @channel,
            announcer: @announcer
          ).perform
        end
      end
    end
  end
end
