module Dolma
  class Checklist < Base
    def self.create(name:, card:)
      new Trello::Checklist.create name: name, card_id: card.id
    end

    def select_or_create_item(card)
      if items.size == 0
        Cli.say "No to-dos found"
        title = ask("Input to-do [#{card.name}]:").presence || card.name
        add_item(title)
      else
        Cli.table(items, title: "#{card.name} (#{name})")
      end
    end

    private

      def items
        super.map { |obj| Item.new(obj) }
      end

      def add_item(title)
        Item.new_from_json super(title)
      end
  end
end
