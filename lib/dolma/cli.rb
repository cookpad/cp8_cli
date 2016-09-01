require "colored"
require "highline"
require "dolma/cli/table"

module Dolma
  module Cli
    @highline = HighLine.new

    def self.table(items, title:)
      Table.new(items, title: title).pick
    end

    def self.say(*args)
      @highline.say(*args)
    end

    def self.ask(*args)
      @highline.ask(*args)
    end

    def self.title(*args)
      @highline.ask(*args)
    end

    def self.error(*args)
      @highline.error(*args)
      exit(false)
    end

    def self.run(command)
      title(command)
      error "Error running: #{command}" unless system(command)
    end
  end
end
