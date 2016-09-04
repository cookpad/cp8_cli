require "dolma/table/row"

module Dolma
  class Table
    def initialize(records)
      @records = records
    end

    def pick(title = nil)
      Cli.title title if title
      render_table
      index = Cli.ask("Pick one:", Integer)
      @records[index - 1]
    end

    private

      def render_table
        if @records.size > 0
          Cli.table rows
        else
          Cli.say "No records found"
        end
      end

      def rows
        @records.each_with_index.map do |record, index|
          Row.new(record, index).to_h
        end
      end
  end
end
