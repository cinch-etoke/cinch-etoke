require "cinch/plugins/etoke_framework/formatter"

module Cinch
  module Plugins
    module EtokeFramework
      # TODO: Rename to 'Messages' or something
      class Announcer
        def session_started(starter)
          Formatter.default "#{starter} has called for an etoke! Type !join to join in!"
        end

        def etoke_already_exists
          Formatter.default "THERE'S ALREADY AN ETOKE IDIOT!!!!"
        end

        def etoke_requested_but_none_exists
          Formatter.default "NO ETOKE ON THIS CHANNEL ATM BRO ILL MAKE ONE FOR YOU H/O"
        end

        def toker_attempted_to_join_own_etoke
          Formatter.default "GREAT JOB IDIOT ITS YOUR GODDAMN ETOKE"
        end

        def toker_is_already_in_the_etoke
          Formatter.default "HEY ASSHOLE YOU'RE ALREADY IN THE ETOKE"
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

        def autotoke_starting(tokers:, starter:)
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
