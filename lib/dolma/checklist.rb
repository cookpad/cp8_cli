module Dolma
  class Checklist < Base
    has_many :items

    def self.create(name:, card:)
      new Trello::Checklist.create name: name, card_id: card.id
    end

    def add_item(title)
      Item.new_from_json super(title)
    end
  end
end
