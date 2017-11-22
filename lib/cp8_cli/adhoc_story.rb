module Cp8Cli
  class AdhocStory
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

      attr_reader :title

      def branch
        @_branch ||= Branch.current
      end

      def create_wip_pull_request
        pr = PullRequest.new(title: title, from: branch.current.name, to: branch.target)
        pr.open
      end
  end
end
