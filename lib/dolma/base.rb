module Dolma
  class Base < SimpleDelegator
    def self.fields
      [:name]
    end
  end
end
