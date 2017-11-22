require "cp8_cli/github/base"
require "cp8_cli/repo"

module Cp8Cli
  module Github
    class PullRequest < Base
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
          repo.url + "/compare/#{target}...#{escape from}?#{url_query}"
        end

        def url_query
          {
            title: title_with_prefixes,
            body: body_with_release_note,
            expand: expand_query
          }.to_query
        end

        def expand_query
          if expand
            "1"
          end
        end

        def body_with_release_note
          body.to_s + release_note.to_s
        end

        def prefixes
          prefixes = []
          prefixes << "[WIP]" if options[:wip]
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
end
