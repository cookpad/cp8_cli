require "trello_flow/table/row"

module TrelloFlow
  class Table
    def self.pick(records, title: nil)
      new(records).pick(title)
    end

    def initialize(records)
      @records = records.to_a.sort_by(&:position)
    end

    def pick(title = nil)
      return if records.none?
      Cli.title title if title
      render_table
      index = Cli.ask("Pick one:", Integer)
      records[index - 1]
    end

    private

      attr_reader :records

      def render_table
        if records.size > 0
          Cli.table rows
        else
          Cli.say "No records found"
        end
      end

      def rows
        records.each_with_index.map do |record, index|
          Row.new(record, index).to_h
        end
      end
  end
end
