module Cp8Cli
  module Commands
    class Submit
      def initialize(options = {})
        @options = options
      end

      def run
        branch.push
        branch.open_pr
      end

      private

        attr_reader :options

        def branch
          @_branch ||= Branch.current
        end
    end
  end
end
