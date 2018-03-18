require "cp8_cli/adhoc_story"
require "cp8_cli/github/issue"

module Cp8Cli
  module Commands
    class Start
      def initialize(name)
        @name = name
      end

      def run
        check_version
        if story
          story.branch.checkout
          story.start
        else
          Command.error "No name/url provided"
        end
      end

      private

        attr_reader :name

        def check_version
          unless Version.latest?
            Command.error "Your `cp8_cli` version is out of date. Please run `gem update cp8_cli`."
          end
        end

        def story
          @_story ||= find_or_create_story
        end

        def find_or_create_story
          if name.to_s.start_with?("https://github.com")
            Github::Issue.find_by_url(name)
          elsif name.present?
            AdhocStory.new(name)
          end
        end
    end
  end
end
