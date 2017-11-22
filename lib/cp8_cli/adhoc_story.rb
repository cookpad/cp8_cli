module Cp8Cli
  class AdhocStory
    attr_reader :title

    def initialize(title)
      @title = title
    end

    def start
      # noop for now
    end

    def assign(user)
      # noop for now
    end

    def short_link
      nil
    end

    private

      def create_wip_pull_request
        #PullRequest.submit(from:, target:, title: title, wip: true)
      end
  end
end
