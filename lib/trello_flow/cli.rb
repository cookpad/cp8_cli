require "colored"
require "forwardable"
require "highline"
require "hirb-colors"
require "hirb"

module TrelloFlow
  class Cli
    class << self
      extend Forwardable
      def_delegators :client, :table, :open_url, :say, :success, :ask, :title, :error, :run, :read
      attr_accessor :client
    end

    self.client = Cli.new

    def table(items)
      puts Hirb::Helpers::AutoTable.render(items, unicode: true)
    end

    def open_url(url)
      return title(url) if ENV['BROWSER'] == 'echo'
      `open \"#{url}\"`
    end

    def say(*args)
      highline.say(*args)
    end

    def success(message)
      highline.say(message.green.bold)
    end

    def ask(message, type = nil)
      highline.ask(message, type)
    end

    def title(message)
      highline.say(message.bold)
    end

    def error(message)
      say(message.red.bold)
      exit(false)
    end

    def run(command)
      title(command)
      system(command) || error("Error running: #{command}")
    end

    def read(command)
      `#{command}`.strip.presence
    end

    private

      def highline
        @_highline ||= HighLine.new
      end
  end
end
