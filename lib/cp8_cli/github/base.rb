require "active_support"
require "octokit"

module Cp8Cli
  module Github
    class Base
      cattr_accessor :client

      def self.configure(token:)
        self.client = Octokit::Client.new(access_token: token)
      end
    end
  end
end
