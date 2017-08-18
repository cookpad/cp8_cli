require "trello_flow/repo"

module TrelloFlow
  class PullRequest
    def initialize(from:, target:, story: nil, **options)
      @story = story
      @from = from
      @target = target
      @options = options
    end

    def open
      Cli.open_url url
    end

    private

      attr_reader :story, :from, :target, :options

      def url
        repo.url + "/compare/#{target}...#{from}?expand=1&title=#{escape title_with_prefixes}&body=#{escape body}"
      end

      def title
        return unless story
        story_name + " [Delivers ##{story.short_link}]"
      end

      def story_name
        story.name.gsub %("), %(')
      end

      def body
        return unless story
        body = "Trello: #{story.short_url}"
        body << release_note unless release_branch?
        body
      end

      def release_note
        "\n\n_Release note: #{story_name}_"
      end

      def prefixes
        prefixes = []
        prefixes << "[WIP]" if options[:wip]
        prefixes << "[#{target.titleize}]" if release_branch?
        prefixes.join(" ")
      end

      def release_branch?
        target != "master"
      end

      def title_with_prefixes
        "#{prefixes} #{title}".strip
      end

      def escape(text)
        URI.escape text.to_s.strip
      end

      def repo
        @_repo ||= Repo.new
      end
  end
end
