module TrelloFlow
  module Api
    class List < Base
      has_many :cards

      def self.fields
        [:name]
      end
    end
  end
end
