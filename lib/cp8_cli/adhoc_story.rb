require "cp8_cli/story"

module Cp8Cli
  class AdhocStory < Story
    attr_reader :title

    def initialize(title)
      @title = title
    end

    def summary
      # noop
    end

    def url
      "#{Repo.current.url}/tree/#{Branch.current}"
    end

    private

      def assign
        # noop
      end
  end
end
