module Dolma
  class Item < Base
    def self.fields
      [:description, :owners]
    end

    def self.find(checklist_id, item_id)

    end

    def self.new_from_json(json)
      new Trello::Item.new(JSON.parse(json))
    end

    def card
      @_card ||= checklist.card
    end

    def checklist
      @_checklist ||= Checklist.find checklist_id
    end

    def description
      description = name_without_mentions
      description = checkmark + description if complete?
      description
    end

    def owners
      mentions.join(", ")
    end

    def color
      :green if complete?
    end

    def assign(owner)
      return if mentions.include?(owner)
      client.put("/cards/#{card.id}/checklist/#{checklist.id}/checkItem/#{id}/name", value: name_without_mentions + " @#{owner}")
    end

    def to_param
      name_without_mentions.parameterize[0..50]
    end

    def name_without_mentions
      str = name
      mentions.each do |mention|
        str = str.gsub(mention, "")
      end
      str.strip
    end

    private

      def checklist_id
        attributes[:checklist_id]
      end

      def mentions
        name.scan(/(@\S+)/).flatten
      end

      def checkmark
        "\u2713 "
      end
  end
end
