module TrelloFlow
  module Api
    class Card < Base
      has_many :checklists

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

      private

        def member_ids
          attributes["idMembers"] || []
        end
    end
  end
end
