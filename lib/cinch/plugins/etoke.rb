require 'cinch'
require "cinch/plugins/cinch_bridge/timer_starter"
require "cinch/plugins/etoke/version"
require "cinch/plugins/etoke_framework/announcer"
require "cinch/plugins/etoke_framework/etoke_performer"
require "cinch/plugins/etoke_framework/formatter"
require "cinch/plugins/etoke_framework/session"
require "cinch/plugins/etoke_framework/session_registry"

module Cinch
  module Plugins
    class Etoke
      include Cinch::Plugin
      include Cinch::Plugins::EtokeFramework

      def initialize(bot)
        super(bot)

        timer_starter = CinchBridge::TimerStarter.new(bot: bot)
        @sessions = SessionRegistry.new(timer_starter: timer_starter)
      end

      # Response matchers

      match "etoke", method: :etoke
      private def etoke(m)
        session = @sessions.find(m.channel)
        if session.nil? || session.finished?
          @sessions.create(channel: m.channel, starter: m.user.nick)
        else
          m.reply Announcer.new.etoke_already_exists
        end
      end

      match /join|in|imin/i, method: :join
      private def join(m)
        session = @sessions.find(m.channel)

        if session.nil? || session.finished?
          m.reply Announcer.new.etoke_requested_but_none_exists
          @sessions.create(channel: m.channel, starter: m.user.nick)
          return
        end

        if session.tokers.include? m.user.nick
          reply_with_toker_exists_message(m, session)
          return
        end

        session.add_toker(m.user.nick)
      end

      match /retoke/i, method: :retoke
      private def retoke(m)
        session = @sessions.find(m.channel)

        if session.nil? || !session.eligible_for_retoke?
          m.reply Announcer.new.cannot_retoke
          return
        end

        session.retoke
      end

      match /start(?! anyway)/i, method: :start
      private def start(m)
        session = @sessions.find(m.channel)

        if session.nil? || session.finished?
          m.reply Announcer.new.etoke_started_but_none_exists
          return
        end

        if m.user.nick != session.starter
          m.reply Announcer.new.attempted_etoke_theft(session.starter)
          return
        end

        session.start
      end

      match /start anyway/i, method: :start_anyway
      private def start_anyway(m)
        session = @sessions.find(m.channel)

        if session.nil? || session.finished?
          m.reply Announcer.new.etoke_started_but_none_exists
          return
        end

        session.start
      end

      # Helper methods

      private def reply_with_toker_exists_message(m, session)
        if session.starter == m.user.nick
          m.reply Announcer.new.toker_attempted_to_join_own_etoke
        else
          m.reply Announcer.new.toker_is_already_in_the_etoke
        end
      end
    end
  end
end
