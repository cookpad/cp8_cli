module Cp8Cli
  class AdhocStory
    attr_reader :title

    def initialize(title)
      @title = title
    end

    def start
      create_wip_pull_request
    end

    def short_link
      nil
    end

    private

      def branch
        @_branch ||= Branch.current
      end

      def create_wip_pull_request
        branch.build_pull_request.open(prefixes: :wip)
      end
  end
end
