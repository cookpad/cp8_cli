module Cp8Cli
  module Commands
    class Ci
      def run
        Branch.current.open_ci # TODO: move to /commands
      end
    end
  end
end
