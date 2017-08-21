require "octokit"

module TrelloFlow
  module Github
    class Base
      cattr_accessor :client

      def self.configure(token:)
        self.client = Octokit::Client.new(token: token)
      end
    end
  end
end
