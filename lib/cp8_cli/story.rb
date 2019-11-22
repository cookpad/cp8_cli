module Cp8Cli
  class Story
    require "shellwords"

    def start
      checkout_branch
      create_empty_commit
      push_branch
      create_draft_pull_request
      assign
      Command.title "Created draft PR, run `cp8 open` to view."
    end

    private

      def checkout_branch
        branch.checkout
      end

      def create_empty_commit
        Command.run "git commit --allow-empty -m#{commit_message} #{skip_ci}", title: "Creating initial commit"
      end

      def commit_message
        escaped_title
      end

      def escaped_title
        Shellwords.escape(title)
      end

      def skip_ci
        "-m'[skip ci]'"
      end

      def push_branch
        branch.push
      end

      def create_draft_pull_request
        Github::PullRequest.create(
          from: branch.name,
          title: PullRequestTitle.new(title).run,
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
