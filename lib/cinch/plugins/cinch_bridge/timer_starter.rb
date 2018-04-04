module Cinch::Plugins::CinchBridge
  class TimerStarter
    def initialize(bot:)
      @bot = bot
    end

    def set(interval, options={}, &block)
      options = {
        method: :timer,
        stop_automatically: true,
        shots: 1,
        threaded: true,
        interval: interval
      }.merge(options)
      
      block ||= self.method(options[:method])
      timer = Cinch::Timer.new(@bot, options, &block)
      timer.start

      timer
    end
  end

  class NullTimerStarter
    def set(interval, options={}, &block)
    end
  end
end
