require "spyke"
require "trello_flow/trello/json_parser"
require "trello_flow/trello/error_handler"

module TrelloFlow
  module Trello
    class Base < Spyke::Base
      require "trello_flow/trello/board"
      require "trello_flow/trello/card"
      require "trello_flow/trello/label"
      require "trello_flow/trello/list"
      require "trello_flow/trello/member"

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
