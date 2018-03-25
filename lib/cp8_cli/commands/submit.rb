module Cp8Cli
  module Commands
    class Submit
      def initialize(options = {})
        @options = options
      end

      def run
        branch.push
        pull_request.open
      end

      private

        attr_reader :options

        def branch
          @_branch ||= Branch.current
        end

        def pull_request
          Github::PullRequest.new(
            from: branch,
            title: PullRequestTitle.new(branch.story&.title, prefixes: options.keys).run,
            body: PullRequestBody.new(branch.story).run
          )
        end
    end
  end
end
