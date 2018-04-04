require 'cinch'
require "cinch/plugins/cinch_bridge/timer_starter"
require "cinch/plugins/etoke/version"
require "cinch/plugins/etoke_framework/announcer"
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
        @sessions.create_session(channel: m.channel, starter: m.user.nick)
      rescue SessionRegistry::SessionExistsForChannelError
        m.reply Announcer.new.etoke_already_exists
      end

      match /join|in|imin/i, method: :join
      private def join(m)
        session = @sessions.find(m.channel)
        session.add_toker(m.user.nick)
      rescue SessionRegistry::SessionNotFoundError
        create_new_etoke_for_toker(m, session)
      rescue Session::TokerExistsError
        reply_with_toker_exists_message(m, session)
      end

      # Helper methods

      private def reply_with_toker_exists_message(m, session)
        if session.starter == m.user.nick
          m.reply Announcer.new.toker_attempted_to_join_own_etoke
        else
          m.reply Announcer.new.toker_is_already_in_the_etoke
        end
      end

      private def create_new_etoke_for_toker(m, session)
        m.reply Announcer.new.etoke_requested_but_none_exists
        @sessions.create_session(channel: m.channel, starter: m.user.nick)
      end
    end
  end
end
