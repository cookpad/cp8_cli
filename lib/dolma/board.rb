module Dolma
  class Board < Base
    has_many :lists

    def self.all
      Trello::Board.all.map { |obj| new(obj) }
    end
  end
end
