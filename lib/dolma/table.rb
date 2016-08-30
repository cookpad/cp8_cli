module Dolma
  class Table
    include Hirb::Console

    def initialize(records, title: nil)
      @records = records
      @title = title
    end

    def show
      say @title.bold if @title
      if @records.size > 0
        table rows, unicode: true
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

      def rows
        @records.each_with_index.map do |record, index|
          Row.new(record, index).to_h
        end
      end
  end
end
