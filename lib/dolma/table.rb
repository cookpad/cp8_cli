require "hirb"
require "highline/import"

module Dolma
  class Table
    include Hirb::Console

    def initialize(records)
      @records = records
    end

    def show
      if @records.size > 0
        table data_with_index, fields: [:num] + fields, unicode: true
      else
        say "No records found"
      end
    end

    def pick
      show
      index = ask "Pick one:", Integer
      @records[index - 1]
    end

    private

      def data_with_index
        @records.each_with_index.map do |record, index|
          data = { num: index + 1 }
          fields.each { |field| data[field] = record.send(field) }
          data
        end
      end

      def fields
        @fields ||= @records.first.class.fields
      end
  end
end
