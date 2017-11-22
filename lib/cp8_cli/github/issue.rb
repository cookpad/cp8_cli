require "cp8_cli/github/base"
require "cp8_cli/github/parsed_url"
require "cp8_cli/github/parsed_short_link"
require "cp8_cli/storyable"

module Cp8Cli
  module Github
    class Issue < Base
      include Storyable

      def initialize(number:, repo:, attributes:)
        @number = number
        @repo = repo
        @attributes = attributes
      end

      def self.fields
        [:title]
      end

      def self.find_by_url(url)
        url = ParsedUrl.new(url)
        issue = client.issue(url.repo, url.number)
        new number: url.number, repo: url.repo, attributes: issue
      end

      def self.find_by_short_link(short_link)
        short_link = ParsedShortLink.new(short_link)
        issue = client.issue(short_link.repo, short_link.number)
        new number: short_link.number, repo: short_link.repo, attributes: issue
      end

      def title
        attributes[:title]
      end

      def pr_title
        title
      end

      def url
        attributes[:html_url]
      end

      def summary
        "Closes #{short_link}"
      end

      def start
        assign CurrentUser.new
      end

      def short_link
        "#{repo}##{number}"
      end

      private

        attr_reader :number, :repo, :attributes

        def assign(user)
          # add_assignes not released as gem yet https://github.com/octokit/octokit.rb/pull/894
          client.post "#{Octokit::Repository.path repo}/issues/#{number}/assignees", assignees: [user.github_login]
        end

    end
  end
end
