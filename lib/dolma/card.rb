module Dolma
  class Card < Base
    def self.find_by_url(url)
      return if url.blank?
      id = url.scan(/\/c\/(.+)\//).flatten.first
      new Trello::Card.find(id)
    end

    def find_or_create_checklist
      if checklists.size == 0
        Cli.say "No to-do list found. Added blank"
        Checklist.create(card: self, name: "To-Do")
      else
        checklists.first
      end
    end

    private

      def checklists
        super.map { |obj| Checklist.new(obj) }
      end
  end
end
