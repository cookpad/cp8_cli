require "trello_flow/github"

module TrelloFlow
  module Github
    class Issue
      def initialize(id:, repo:, **attributes)
        @id = id
        @repo = repo
        @attributes = attributes
      end

      def self.fields
        [:name]
      end

      def self.find_by_url(url)
        parts = url.split("/")
        repo = parts[3, 2].join("/")
        id = parts.last
        new id: id, repo: repo, attributes: Github.client.issue(repo, id)
      end

      def name
        attributes[:title]
      end

      def start
        #move_to board.lists.started
      end

      def finish
        #move_to board.lists.finished
      end

      def accept
        #move_to board.lists.accepted
      end

      def assign(user)
        require 'pry'; binding.pry
        Github.client.add_assignees(repo, id, [user])
      end

      def add_label(label)
        self.class.request(:post, "cards/#{id}/idLabels", value: label.id)
      end

      def attach(url:)
        self.class.request(:post, "cards/#{id}/attachments", url: url)
      end

      def short_link
        url.scan(/\/c\/(.+)\//).flatten.first
      end

      def short_url
        attributes[:shortUrl]
      end

      private

        attr_reader :id, :repo, :attributes

        def move_to(list)
          self.class.with("cards/:id/idList").where(id: id, value: list.id).put
        end

        def member_ids
          attributes["idMembers"] || []
        end
    end
  end
end
