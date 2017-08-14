module TrelloFlow
  module Trello
    class Board < Base
      has_many :lists
      has_many :labels
      scope :active, -> { where(filter: "open") }

      def self.fields
        [:name]
      end
    end
  end
end
