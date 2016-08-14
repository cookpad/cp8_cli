module Dolma
  class CheckItem < Base
    def self.fields
      [:name, :owners]
    end

    def name
      name = description_without_mentions
      name = checkmark + name if completed?
      name
    end

    def owners
      mentions.join(", ")
    end

    def color
      :green if completed?
    end

    private

      def mentions
        description.scan(/(@\S+)/).flatten
      end

      def description_without_mentions
        str = description
        mentions.each do |mention|
          str = str.gsub(mention, "")
        end
        str
      end

      def description
        self["name"]
      end

      def state
        self["state"]
      end

      def completed?
        state == "complete"
      end

      def checkmark
        "\u2713 "
      end
  end
end
