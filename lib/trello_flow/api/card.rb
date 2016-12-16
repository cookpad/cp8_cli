module TrelloFlow
  module Api
    class Card < Base
      has_many :checklists
      belongs_to :board, foreign_key: "idBoard"

      def self.fields
        [:name]
      end

      def self.find_by_url(url)
        id = url.scan(/\/c\/(.+)\//).flatten.first
        find(id)
      end

      def self.for(user)
        with("members/:username/cards/open").where(username: user.username)
      end

      def move_to(list)
        self.class.with("cards/:id/idList").where(id: id, value: list.id).put
      end

      def start
        move_to board.lists.started
      end

      def finish
        move_to board.lists.finished
      end

      def add_member(user)
        return if member_ids.include?(user.id)
        self.class.with("cards/:id/members").where(id: id, value: user.id).post
      end

      def find_or_create_checklist
        Table.pick(checklists) || Checklist.create(idCard: id, name: "To-Do")
      end

      def url
        attributes[:shortUrl]
      end

      def to_param
        name.parameterize[0..50]
      end

      private

        def member_ids
          attributes["idMembers"] || []
        end
    end
  end
end
