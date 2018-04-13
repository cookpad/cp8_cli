require "colored"
require "active_support/core_ext/module/delegation"
require "highline"
require "tty-prompt"

module Cp8Cli
  class Command
    class << self
      delegate :open_url, :say, :success, :ask, :title, :error, :run, :read, to: :client
      attr_accessor :client
    end

    self.client = new

    def open_url(url)
      return title(url) if ENV['BROWSER'] == 'echo'
      `open \"#{url}\"`
    end

    def title(message)
      highline.say(message.bold)
    end

    def say(*args)
      highline.say(*args)
    end

    def success(message)
      highline.say(message.green.bold)
    end

    def ask(message, required: true, default: nil)
      tty.ask(message, required: required, default: default)
    end

    def error(message)
      say(message.red.bold)
      exit(false)
    end

    def run(command, title: nil)
      title(title) if title
      say(command)
      system(command) || error("Error running: #{command}")
    end

    def read(command)
      `#{command}`.strip.presence
    end

    private

      def highline
        @_highline ||= HighLine.new
      end

      def tty
        @_tty ||= TTY::Prompt.new
      end
  end
end
