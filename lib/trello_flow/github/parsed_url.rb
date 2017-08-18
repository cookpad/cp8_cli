module TrelloFlow
  module Github
    class ParsedUrl
      def initialize(url)
        @url = url
      end

      def id
        parts.last
      end

      def repo
        parts[3, 2].join("/")
      end

      private

        attr_accessor :url

        def parts
          url.split("/")
        end
    end
  end
end
