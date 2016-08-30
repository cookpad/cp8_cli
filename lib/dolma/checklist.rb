module Dolma
  class Checklist < Base
    def self.create(name:, card:)
      new Trello::Checklist.create name: name, card_id: card.id
    end

    def items
      super.map { |obj| Item.new(obj) }
    end

    def add_item(title)
      Item.new_from_json super(title)
    end
  end
end
