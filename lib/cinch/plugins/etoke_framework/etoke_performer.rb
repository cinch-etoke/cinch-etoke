module Cinch
  module Plugins
    module EtokeFramework
      class EtokePerformer
        def initialize(session:, timer_starter:, channel:, announcer:)
          @session = session
          @timer_starter = timer_starter
          @channel = channel
          @announcer = announcer
        end

        def perform
          @channel.send Formatter.default "5.........."
          @timer_starter.set(1) { @channel.send Formatter.default "4....  ...." }
          @timer_starter.set(2) { @channel.send Formatter.default "3...    ..." }
          @timer_starter.set(3) { @channel.send Formatter.default "2..      .." }
          @timer_starter.set(4) { @channel.send Formatter.default "1.        ." }
          @timer_starter.set(5) { etoke_banner }
          @timer_starter.set(5) { @session.finish }
        end

        private def etoke_banner
          a = rand(0..16).to_s
          b = rand(0..16).to_s
          until(a != b) do
             b = rand(0..16).to_s
          end

          @channel.send("\002\003" + a + "," + b + "ETOKE" + "\003" + b + "," + a + "ETOKE" + "\003" + a + "," + b + "ETOKE")
          @channel.send("\002\003" + b + "," + a + "ETOKE" + "\003" + a + "," + b + "ETOKE" + "\003" + b + "," + a + "ETOKE")
          @channel.send("\002\003" + a + "," + b + "ETOKE" + "\003" + b + "," + a + "ETOKE" + "\003" + a + "," + b + "ETOKE")
        end
      end
    end
  end
end
