module TrelloFlow
  class Table
    class Row
      attr_reader :num

      COLOR_TRANSLATIONS = {
        "purple" => "magenta",
        "orange" => "yellow",
        "sky" => "cyan",
        "pink" => "red",
        "lime" => "green"
      }

      def initialize(record, index)
        @record = record
        @num = index + 1
      end

      def to_h
        result = { "#": num }
        fields.each do |field|
          result[field] = colorize record.send(field)
        end
        result
      end

      private

        attr_reader :num, :record

        def colorize(str)
          return str unless record.respond_to?(:color)
          "■".send(color) + " #{str}"
        end

        def color
          COLOR_TRANSLATIONS[record.color] || record.color || :white
        end

        def fields
          @_fields ||= record.class.fields
        end
    end
  end
end
