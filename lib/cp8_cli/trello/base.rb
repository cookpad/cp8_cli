require "spyke"
require "cp8_cli/trello/json_parser"
require "cp8_cli/trello/error_handler"

module Cp8Cli
  module Trello
    class Base < Spyke::Base
      require "cp8_cli/trello/board"
      require "cp8_cli/trello/card"
      require "cp8_cli/trello/label"
      require "cp8_cli/trello/list"
      require "cp8_cli/trello/member"

      include_root_in_json false
      cattr_accessor :token

      def self.configure(key:, token:)
        self.connection = Faraday.new(url: "https://api.trello.com/1", params: { key: key, token: token }) do |c|
          c.request  :json
          c.use JSONParser
          c.use ErrorHandler
          c.adapter  Faraday.default_adapter

          # For trello api logging
          # require "faraday/conductivity"
          # c.use       Faraday::Conductivity::ExtendedLogging
        end
        self.token = token
      end

      def position
        self[:pos].to_f
      end
    end
  end
end
