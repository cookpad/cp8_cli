module TrelloFlow
  module Github
    class ParsedShortLink
      def initialize(short_link)
        @short_link = short_link
      end

      def number
        parts.last
      end

      def repo
        parts.first
      end

      private

        attr_accessor :short_link

        def parts
          short_link.split("#")
        end
    end
  end
end
