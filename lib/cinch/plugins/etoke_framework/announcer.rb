module Cinch
  module Plugins
    module EtokeFramework
      class Announcer
        def session_started(starter)
          Formatter.default "#{starter} has called for an etoke! Type !join to join in!"
        end

        def toker_added(toker)
          Formatter.default "#{toker} has joined the etoke! Type !join to join them!"
        end

        def two_minute_warning(tokers:, starter:)
          if tokers.count == 1
            Formatter.default "#{starter} wants to etoke, won't someone join them? Auto-(alone)-toke in 2 minutes."
          else
            Formatter.default "Looks like #{starter} is asleep #{tokers.join(", ")}. Get ready for the auto-toke in 2 minutes, or use '!start anyway' to start now"
          end
        end

        def auto_toke_starting(tokers:, starter:)
          if tokers.count == 1
            Formatter.default "Poor #{starter} has to toke alone. Auto-toke commencing. Hit it!"
          else
            "#{starter} is spaced out; auto-toke! Get ready to smoke #{tokers.join(", ")}"
          end
        end

        def toke_starting(tokers:, starter:)
          if tokers.count == 1
            Formatter.default "#{starter} is toking alone! It’s time to _\\|/_ ( .__.)  . o 0 ( smoke weed ) in...."
          else
            "#{tokers.join(", ")} get excited!!! It’s time to _\\|/_ ( .__.)  . o 0 ( smoke weed ) in...."
          end
        end
      end
    end
  end
end
