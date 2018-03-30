module Cp8Cli
  class Story
    def start
      checkout_branch
      create_empty_commit
      push_branch
      create_wip_pull_request
      assign
    end

    private

      def checkout_branch
        branch.checkout
      end

      def create_empty_commit
        Command.run "git commit --allow-empty -m\"#{commit_message}\""
      end

      def commit_message
        "Started: #{escaped_title}"
      end

      def escaped_title
        title.gsub('"', '\"')
      end

      def push_branch
        branch.push
      end

      def create_wip_pull_request
        Github::PullRequest.create(
          title: wip_pr_title,
          from: branch.name
        )
      end

      def wip_pr_title
        PullRequestTitle.new(title, prefixes: [:wip]).run
      end

      def branch
        @_branch ||= Branch.from_story(self)
      end
  end
end
