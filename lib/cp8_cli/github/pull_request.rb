require "cp8_cli/github/base"
require "cp8_cli/repo"

module Cp8Cli
  module Github
    class PullRequest < Base
      def initialize(from:, target:, title: nil, body: nil)
        @title = title
        @body = body
        @from = from
        @target = target
      end

      def open(expand: 1)
        Command.open_url(url + "&expand=#{expand}")
      end

      private

        attr_reader :from, :target, :title, :body

        def url
          repo.url + "/compare/#{target}...#{escape from}?#{url_query}"
        end

        def url_query
          {
            title: title,
            body: body,
          }.to_query
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
