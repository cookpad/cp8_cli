require "cp8_cli/repo"

module Cp8Cli
  class PullRequest
    def initialize(from:, target:, story: nil, **options)
      @story = story
      @from = from
      @target = target
      @options = options
    end

    def open
      Command.open_url url
    end

    private

      attr_reader :story, :from, :target, :options

      def url
        repo.url + "/compare/#{target}...#{escape from}?expand=1&title=#{escape title_with_prefixes}&body=#{escape body}"
      end

      def title
        return unless story
        story.pr_title
      end

      def body
        return unless story
        body = story.summary
        body << release_note unless release_branch?
        body
      end

      def release_note
        "\n\n_Release note: #{story.title}_"
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
        CGI.escape(text.to_s.strip)
      end

      def repo
        @_repo ||= Repo.current
      end
  end
end
