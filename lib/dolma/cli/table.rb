require "hirb-colors"
require "hirb"
require "dolma/cli/row"

module Dolma
  module Cli
    class Table
      include Hirb::Console

      def initialize(records, title: nil)
        @records = records
        @title = title
      end

      def show
        Cli.say @title.bold if @title
        if @records.size > 0
          table rows, unicode: true
        else
          Cli.say "No records found"
        end
      end

      def pick
        show
        index = Cli.ask("Pick one:", Integer)
        @records[index - 1]
      end

      private

        def rows
          @records.each_with_index.map do |record, index|
            Row.new(record, index).to_h
          end
        end
    end
  end
end
