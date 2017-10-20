require "cp8_cli/table/row"

module Cp8Cli
  class Table
    def self.pick(records, caption: "Pick one:")
      new(records).pick(caption)
    end

    def initialize(records)
      @records = records.to_a.sort_by(&:position)
    end

    def pick(caption)
      return if records.none?
      render_table
      index = Command.ask(caption, type: Integer)
      records[index - 1]
    end

    private

      attr_reader :records

      def render_table
        if records.size > 0
          Command.table rows
        else
          Command.say "No records found"
        end
      end

      def rows
        records.each_with_index.map do |record, index|
          Row.new(record, index).to_h
        end
      end
  end
end
