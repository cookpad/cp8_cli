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

      def self.for(username)
        with("members/:username/cards/open").where(username: username)
      end

      def find_or_create_checklist
        Table.new(checklists).pick || Checklist.create(idCard: id, name: "To-Do")
      end

      def url
        attributes[:shortUrl]
      end
    end
  end
end
