module Cinch
  module Plugins
    class Etoke
      class Session
        attr_reader :tokers

        def initialize(starter:, options: {})
          @starter = starter
          @tokers = options[:tokers] || []
          @tokers << starter
        end

        def add_toker(toker_name)
          raise TokerExistsError if @tokers.include? toker_name
          @tokers << toker_name
        end

        class TokerExistsError < StandardError; end
      end
    end
  end
end
