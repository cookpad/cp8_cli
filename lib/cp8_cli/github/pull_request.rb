require "cp8_cli/github/base"
require "cp8_cli/repo"

module Cp8Cli
  module Github
    class PullRequest < Base
      def self.create(attributes = {})
        new(attributes).save
      end

      def initialize(from:, to:, title: nil, body: nil)
        @title = title
        @body = body
        @from = from
        @to = to
      end

      def open(expand: 1)
        Command.open_url(url + "&expand=#{expand}")
      end

      def save
        client.create_pull_request(
          repo.shorthand,
          to,
          from,
          title,
          body
        )
      end

      private

        attr_reader :from, :to, :title, :body

        def url
          repo.url + "/compare/#{escape to}...#{escape from}?#{url_query}"
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
