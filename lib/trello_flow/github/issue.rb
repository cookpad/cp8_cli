require "trello_flow/github"
require "trello_flow/github/parsed_url"
require "trello_flow/github/parsed_short_link"

module TrelloFlow
  module Github
    class Issue
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
        issue = Github.client.issue(url.repo, url.number)
        new number: url.number, repo: url.repo, attributes: issue
      end

      def self.find_by_short_link(short_link)
        short_link = ParsedShortLink.new(short_link)
        issue = Github.client.issue(short_link.repo, short_link.number)
        new number: short_link.number, repo: short_link.repo, attributes: issue
      end

      def title
        attributes[:title]
      end

      def pr_title
        title
      end

      def summary
        "Closes #{short_link}"
      end

      def start
        # noop for now
      end

      def finish
        # noop for now
      end

      def accept
        # noop for now
      end

      def assign(user)
        Github.client.add_assignees(repo, number, Github.client.user)
      end

      def add_label(label)
        self.class.request(:post, "cards/#{id}/idLabels", value: label.id)
      end

      def attach(url:)
        self.class.request(:post, "cards/#{id}/attachments", url: url)
      end

      def short_link
        "#{repo}##{number}"
      end

      def short_url
        attributes[:shortUrl]
      end

      private

        attr_reader :number, :repo, :attributes

        def move_to(list)
          self.class.with("cards/:id/idList").where(id: id, value: list.id).put
        end

        def member_ids
          attributes["idMembers"] || []
        end
    end
  end
end
