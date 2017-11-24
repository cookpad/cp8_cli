module Cp8Cli
  class PullRequestBody
    def initialize(story)
      @story = story
    end

    def run
      return unless story

      summary_with_release_note
    end

    private

      attr_reader :story

      def summary_with_release_note
        story.summary + release_note
      end

      def release_note
        "\n\n_Release note: #{story.title}_"
      end
  end
end
