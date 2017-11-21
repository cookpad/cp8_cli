require "cp8_cli/repo"

module Cp8Cli
  class PullRequest
    def initialize(from:, target:, title: nil, body: nil, story: nil, expand: true, **options)
      @title = title
      @body = body
      @from = from
      @target = target
      self.story = story
      @expand = expand
      @options = options
    end

    def open
      Command.open_url url
    end

    private

      attr_reader :from, :target, :expand, :options
      attr_accessor :title, :body, :release_note

      def story=(story)
        return unless story

        self.title = story.pr_title
        self.body = story.summary
        self.release_note = "\n\n_Release note: #{story.title}_"
      end

      def url
        repo.url + "/compare/#{target}...#{escape from}?title=#{escape title_with_prefixes}&body=#{escape body_with_release_note}#{expand_query}"
      end

      def expand_query
        if expand
          "&expand=1"
        end
      end

      def body_with_release_note
        body.to_s + release_note.to_s
      end

      def prefixes
        prefixes = []
        prefixes << "[WIP]" if options[:wip]
        prefixes << "[#{target.titleize}]" if release_branch?
        prefixes.join(" ")
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
