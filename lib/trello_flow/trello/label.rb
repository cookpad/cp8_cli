module TrelloFlow
  module Trello
    class Label < Base
      has_many :cards

      def self.fields
        [:name]
      end

      def position
        name.downcase
      end
    end
  end
end
