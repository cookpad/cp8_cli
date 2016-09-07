module Dolma
  module Api
    class Item < Base
      delegate :card, :card_id, to: :checklist

      def self.fields
        [:description, :owners]
      end

      def self.find(checklist_id, item_id)
        with("checklists/#{checklist_id}/checkItems/#{item_id}").find_one
      end

      def description
        if complete?
          checkmark + name_without_mentions
        else
          name_without_mentions
        end
      end

      def owners
        mentions.join(", ")
      end

      def color
        :green if complete?
      end

      def assign(owner)
        return if mentions.include?(owner)
        self.class.request :put, "cards/#{card_id}/checklist/#{checklist_id}/checkItem/#{id}/name", value: name_without_mentions + " @#{owner}"
      end

      def to_param
        name_without_mentions.parameterize[0..50]
      end

      def name_without_mentions
        (name.split - mentions).join(" ").strip
      end

      private

        def checklist
          @_checklist ||= Checklist.find checklist_id
        end

        def checklist_id
          attributes[:idChecklist]
        end

        def mentions
          name.scan(/(@\S+)/).flatten
        end

        def checkmark
          "\u2713 "
        end

        def complete?
          state == "complete"
        end
    end
  end
end
