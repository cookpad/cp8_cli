module Cp8Cli
  module Commands
    class Open
      def run
        Branch.current.open_story_in_browser
      end
    end
  end
end
