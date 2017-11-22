module Cp8Cli
  class AdhocStory
    attr_reader :title

    def initialize(title)
      @title = title
    end

    def start
      create_wip_pull_request
      branch.open_rull_
      # create_wip_pull_request
      # noop for now
    end

    def short_link
      nil
    end

    private

      def branch
        @_branch ||= Branch.current
      end

      def create_wip_pull_request
        #PullRequest.submit(from:, target:, title: title, wip: true)
      end
  end
end
