module Cp8Cli
  class Story
    def start
      checkout_branch
      create_empty_commit
      push_branch
      create_wip_pull_request
      assign
      Command.say "Created WIP PR, run `cp8 open` to view."
    end

    private

      def checkout_branch
        branch.checkout
      end

      def create_empty_commit
        Command.run "git commit --allow-empty -m\"#{commit_message}\""
      end

      def commit_message
        escaped_title
      end

      def escaped_title
        title.gsub('"', '\"')
      end

      def push_branch
        branch.push
      end

      def create_wip_pull_request
        Github::PullRequest.create(
          from: branch.name,
          title: PullRequestTitle.new(title, prefixes: :wip).run,
          body: PullRequestBody.new(self).run
        )
      end

      def branch
        @_branch ||= Branch.new(branch_name)
      end

      def branch_name
        BranchName.new(user: user, story: self).to_s
      end

      def user
        @_user ||= CurrentUser.new
      end
  end
end
