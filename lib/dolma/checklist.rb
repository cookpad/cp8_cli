module Dolma
  class Checklist < Base
    def self.find(id)
      new Trello::Checklist.find(id)
    end

    def self.create(name:, card:)
      new Trello::Checklist.create name: name, card_id: card.id
    end

    def card
      @_card ||= Card.find card_id
    end

    def select_or_create_item
      if items.size == 0
        Cli.say "No to-dos found"
        title = Cli.ask("Input to-do [#{card.name}]:").presence || card.name
        add_item(title)
      else
        Cli.table(items, title: "#{card.name} (#{name})")
      end
    end

    def items
      super.map { |obj| Item.new(obj) }
    end

    private

      def add_item(title)
        Item.new_from_json super(title)
      end
  end
end
