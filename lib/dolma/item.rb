module Dolma
  class Item < Base
    def self.fields
      [:description, :owners]
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

    private

      def mentions
        name.scan(/(@\S+)/).flatten
      end

      def name_without_mentions
        str = name
        mentions.each do |mention|
          str = str.gsub(mention, "")
        end
        str
      end

      def checkmark
        "\u2713 "
      end
  end
end
