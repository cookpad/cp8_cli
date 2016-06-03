require "colored"

module Dolma
  class Row
    attr_reader :num

    def initialize(record, index)
      @record = record
      @num = index + 1
    end

    def to_h
      result = { "#": @num }
      fields.each do |field|
        result[field] = colorize(@record.send(field))
      end
      result
    end

    private

      def colorize(str)
        return str unless str.respond_to?(color)
        str.send(color)
      end

      def color
        return :white unless @record.respond_to?(:color)
        @record.color
      end

      def fields
        @fields ||= @record.class.fields
      end
  end
end
