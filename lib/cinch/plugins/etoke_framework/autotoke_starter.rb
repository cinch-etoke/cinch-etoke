require 'cinch/plugins/cinch_bridge/timer_starter'

module Cinch
  module Plugins
    module EtokeFramework
      class AutotokeStarter
        def initialize(session)
          @session = session
        end

        def auto_toke
          @session.start
        end
      end
    end
  end
end
