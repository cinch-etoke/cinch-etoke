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

      def initialize(bot)
        super(bot)

        timer_starter = Cinch::Plugins::CinchBridge::TimerStarter.new(bot: bot)
        @sessions = EtokeFramework::SessionRegistry.new(timer_starter: timer_starter)
      end

      match "etoke", method: :etoke
      private def etoke(m)
        @sessions.create_session(channel: m.channel, starter: m.user.nick)
      rescue Cinch::Plugins::EtokeFramework::SessionRegistry::SessionExistsError
        m.reply EtokeFramework::Formatter.default("THERE'S ALREADY AN ETOKE IDIOT!!!!")
      end
    end
  end
end
