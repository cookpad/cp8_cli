require "dolma/table"

module Dolma
  module Api
    class Checklist < Base
      belongs_to :card
      #has_many :items, uri: "checklists/:checklist_id/checkItems"

      def self.fields
        [:name]
      end

      def select_or_create_item
        if items.none?
          item_name = Cli.ask("Input to-do [#{card.name}]:").presence || card.name
          add_item(item_name)
        else
          Table.new(items).pick("#{card.name} (#{name})")
        end
      end

      def items
        attributes[:checkItems].map do |attr|
          Item.new attr.merge(checklist_id: id)
        end
      end

      def card_id
        attributes[:idCard]
      end

      def add_item(name)
        Item.with("checklists/:checklist_id/checkItems").where(checklist_id: id).create(name: name)
        # items.create(name: name)
      end
    end
  end
end
