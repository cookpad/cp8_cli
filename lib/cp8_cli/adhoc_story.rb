module Cp8Cli
  class AdhocStory
    attr_reader :title

    def initialize(title)
      @title = title
    end

    def summary
      nil # noop for now
    end

    def start
      create_wip_pull_request
    end

    def short_link
      nil # noop for now
    end

    private

      def branch
        @_branch ||= Branch.current
      end

      def create_wip_pull_request
        pr = Github::PullRequest.new(title: pr_title, from: branch.current.name, to: branch.target)
        pr.open
      end

      def pr_title
        PullRequestTitle.new(title, prefixes: [:wip]).to_s
      end
  end
end
