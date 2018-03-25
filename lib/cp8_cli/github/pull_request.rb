require "cp8_cli/github/api"
require "cp8_cli/repo"

module Cp8Cli
  module Github
    class PullRequest
      include Api::Client

      def self.create(attributes = {})
        new(attributes).save
      end

      def initialize(from:, to: "master", title: nil, body: nil)
        @title = title
        @body = body
        @from = from
        @to = to
      end

      def open(expand: 1)
        query = base_query.merge(expand: expand)
        url = "#{base_url}?#{query.compact.to_query}"

        Command.open_url(url)
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

        def base_url
          repo.url + "/compare/#{escape to}...#{escape from}"
        end

        def base_query
          {
            title: title,
            body: body,
          }
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
