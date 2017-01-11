module TrelloFlow
  module Api
    class Card < Base
      belongs_to :board, foreign_key: "idBoard"

      def self.fields
        [:name]
      end

      def self.find_by_url(url)
        short_link = url.scan(/\/c\/(.+)\//).flatten.first
        find(short_link)
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

      def url
        attributes[:shortUrl]
      end

      def to_param
        name.parameterize[0..50]
      end

      private

        def move_to(list)
          self.class.with("cards/:id/idList").where(id: id, value: list.id).put
        end

        def member_ids
          attributes["idMembers"] || []
        end
    end
  end
end
