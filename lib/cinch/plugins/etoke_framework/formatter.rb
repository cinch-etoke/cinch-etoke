module Cinch
  module Plugins
    module EtokeFramework
      class Formatter
        def self.default(text)
          "\00309,01#{text}"
        end
      end
    end
  end
end
