require "spyke"
require "dolma/api/json_parser"

module Dolma
  module Api
    class Base < Spyke::Base
      require "dolma/api/card"
      require "dolma/api/checklist"
      require "dolma/api/item"

      include_root_in_json false

      def self.configure(key:, token:)
        self.connection = Faraday.new(url: "https://api.trello.com/1", params: { key: key, token: token }) do |c|
          c.request   :json
          c.use       JSONParser
          c.adapter   Faraday.default_adapter
        end
      end

      def position
        self[:pos].to_f
      end
    end
  end
end