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
      create_wip_pull_request
    end

    def short_link
      nil # noop for now
    end

    def pr_title
      PullRequestTitle.new(title, prefixes: [:wip]).to_s
    end

    private

      def create_wip_pull_request
        pr = Github::PullRequest.new(title: pr_title, from: branch, to: branch.target)
        pr.open
      end
  end
end
