module Cp8Cli
  module Commands
    class Open
      def run
        Branch.current.open_pr
      end
    end
  end
end
