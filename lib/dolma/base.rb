module Dolma
  class Base < SimpleDelegator
    def self.fields
      [:name]
    end

    def self.has_many(association)
      class_eval <<-EORUBY
        def #{association}
          __getobj__.#{association}.map { |obj| #{association.to_s.singularize.classify}.new(obj) }
        end
      EORUBY
    end
  end
end
