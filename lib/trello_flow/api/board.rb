module TrelloFlow
  module Api
    class Board < Base
      has_many :lists
      scope :active, -> { where(filter: "open") }

      def self.fields
        [:name]
      end
    end
  end
end
