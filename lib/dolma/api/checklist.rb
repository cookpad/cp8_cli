require "dolma/table"

module Dolma
  module Api
    class Checklist < Base
      belongs_to :card
      #has_many :items, uri: "checklists/:checklist_id/checkItems"

      def select_or_create_item
        if items.none?
          Cli.say "No to-dos found"
          title = Cli.ask("Input to-do [#{card.name}]:").presence || card.name
          add_item(title)
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

      private

        def add_item(title)
          Item.with("checklists/:checklist_id/checkItems").where(checklist_id: id).create(title: title)
          # items.create(title: title)
        end
    end
  end
end
