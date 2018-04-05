module Cp8Cli
  class Repo
    def self.current
      path = Command.read("git config --get remote.origin.url").match(/github.com[:\/](\S+\/\S+)\.git/)[1]
      new(path)
    end

    def initialize(path)
      @path = path
    end

    def shorthand
      "#{user}/#{name}"
    end

    def url
      "https://github.com/#{shorthand}"
    end

    private

      attr_reader :path

      def user
        path.split('/').first
      end

      def name
        path.split('/').last
      end
  end
end
