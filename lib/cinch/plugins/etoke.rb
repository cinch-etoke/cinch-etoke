require 'cinch'
require "cinch/plugins/etoke/session"
require "cinch/plugins/etoke/version"

module Cinch
  module Plugins
    class Etoke
      include Cinch::Plugin

      match /^etoke$/, method: :etoke
      private def etoke(m)

      end
    end
  end
end
