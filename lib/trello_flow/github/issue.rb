module TrelloFlow
  module Github
    class Issue
      def self.fields
        [:name]
      end

      def self.find_by_url(url)
        #client.issue(
        #Octokit.issue("octokit/octokit.rb", "25")
        raise "trying to start GitHub issue"
        #card = Card.new(url: url)
        #find(card.short_link)
      end

      def start
        move_to board.lists.started
      end

      def finish
        move_to board.lists.finished
      end

      def accept
        move_to board.lists.accepted
      end

      def add_member(user)
        return if member_ids.include?(user.id)
        self.class.request(:post, "cards/#{id}/members", value: user.id)
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

        def move_to(list)
          self.class.with("cards/:id/idList").where(id: id, value: list.id).put
        end

        def member_ids
          attributes["idMembers"] || []
        end

        def client
          @_client ||= octokit
        end

        def octokit
          raise "OCTOKIT_ACCESS_TOKEN env variable not set" unless ENV["OCTOKIT_ACCESS_TOKEN"]
          @_octokit ||= Octokit::Client.new
        end
    end
  end
end
