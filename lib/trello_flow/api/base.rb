require "spyke"
require "trello_flow/api/json_parser"

module TrelloFlow
  module Api
    class Base < Spyke::Base
      require "trello_flow/api/card"
      require "trello_flow/api/checklist"
      require "trello_flow/api/member"
      require "trello_flow/api/item"

      include_root_in_json false
      cattr_accessor :token

      def self.configure(key:, token:)
        self.connection = Faraday.new(url: "https://api.trello.com/1", params: { key: key, token: token }) do |c|
          c.request   :json
          c.use       JSONParser
          c.adapter   Faraday.default_adapter
        end
        self.token = token
      end

      def position
        self[:pos].to_f
      end
    end
  end
end
