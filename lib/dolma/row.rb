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
        custom_color = @record.color if @record.respond_to?(:color)
        custom_color || :white
      end

      def fields
        @fields ||= @record.class.fields
      end
  end
end
