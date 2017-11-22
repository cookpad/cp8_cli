module Cp8Cli
  class PullRequestTitle
    def initialize(story, prefixes: [])
      @story = story
      @prefixes = prefixes
    end

    def to_s
      return unless story

      title_with_prefixes
    end

    private

      attr_reader :story, :prefixes

      def title_with_prefixes
        "#{prefixes_to_text} #{story.pr_title}".strip
      end


      def prefixes_to_text
        prefixes.map do |prefix|
          "[#{prefix.to_s.upcase}]"
        end.join(" ")
      end
  end
end
