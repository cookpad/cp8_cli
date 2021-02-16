require "cp8_cli/github/api"
require "cp8_cli/repo"

module Cp8Cli
  module Github
    class PullRequest
      include Api::Client

      def self.create(attributes = {})
        new(**attributes).save
      end

      def self.find_by(repo:, branch:)
        client.pull_requests(repo.shorthand, head: "#{repo.user}:#{branch}").map do |data|
          new(**data)
        end.first
      end

      def initialize(from: nil, to: "master", title: nil, body: nil, expand: 1, html_url: nil, **attributes)
        @from = from
        @to = to
        @title = title
        @body = body
        @expand = expand
        @html_url = html_url
      end

      def open
        Command.open_url(url)
      end

      def save
        client.create_pull_request(
          repo.shorthand,
          to,
          from,
          title,
          body,
          draft: true,
          accept: "application/vnd.github.shadow-cat-preview" # waiting for https://github.com/octokit/octokit.rb/pull/1114
        )
      end

      private

        attr_reader :from, :to, :title, :body, :expand, :html_url

        def url
          html_url || new_pr_url
        end

        def new_pr_url
          "#{base_url}?#{base_query}"
        end

        def base_url
          repo.url + "/compare/#{escape to}...#{escape from}"
        end

        def base_query
          {
            title: title,
            body: body,
            expand: expand
          }.compact.to_query
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
