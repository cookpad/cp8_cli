require "active_support"
require "active_support/concern"
require "octokit"

module Cp8Cli
  module Github
    class Api
      cattr_accessor :client

      def self.configure(token:)
        self.client = Octokit::Client.new(access_token: token)
      end

      module Client
        extend ActiveSupport::Concern

        def client
          self.class.client
        end

        class_methods do
          def client
            Api.client
          end
        end
      end
    end
  end
end
