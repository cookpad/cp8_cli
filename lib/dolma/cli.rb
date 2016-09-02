require "colored"
require "highline"
require "dolma/cli/table"

module Dolma
  module Cli
    @highline = HighLine.new

    def self.table(items, title:)
      Table.new(items, title: title).pick
    end

    def self.open(url)
      if ENV['BROWSER'] == 'echo'
        title url
      else
        run "open \"#{url}\""
      end
    end

    def self.say(*args)
      @highline.say(*args)
    end

    def self.success(message)
      @highline.say(message.green.bold)
    end

    def self.ask(*args)
      @highline.ask(*args)
    end

    def self.title(message)
      @highline.say(message.bold)
    end

    def self.error(message)
      @highline.say(message.red.bold)
      exit(false)
    end

    def self.run(command)
      title(command)
      error "Error running: #{command}" unless system(command)
    end
  end
end
