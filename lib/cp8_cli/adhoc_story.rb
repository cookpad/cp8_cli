require "cp8_cli/storyable"

module Cp8Cli
  class AdhocStory
    include Storyable
    attr_reader :title

    def initialize(title)
      @title = title
    end

    def summary
      nil # noop for now
    end

    def start
      create_empty_commit
      push_branch
      create_wip_pull_request
    end

    def short_link
      nil # noop for now
    end

    def pr_title
      PullRequestTitle.new(title, prefixes: [:wip]).run
    end

    def branch_identifier
      title.parameterize[0..50]
    end

    private

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
          title: pr_title,
          from: branch.name
        )
      end
  end
end
