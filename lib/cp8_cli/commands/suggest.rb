module Cp8Cli
  module Commands
    class Suggest

      def run
        cache_original_branch

        suggestion_branch.checkout
        suggestion_branch.push
        pull_request.open(expand: false)

        original_branch.checkout
        original_branch.reset
      end

      private

        def cache_original_branch
          original_branch # Keep reference for later
        end

        def original_branch
          @_original_branch ||= Branch.current
        end

        def suggestion_branch
          @_suggestion_branch ||= Branch.suggestion
        end

        def pull_request
          Github::PullRequest.new(
            from: suggestion_branch,
            to: original_branch,
          )
        end

    end
  end
end
