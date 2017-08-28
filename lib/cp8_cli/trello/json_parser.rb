require "multi_json"

module Cp8Cli
  module Trello
    class JSONParser < Faraday::Response::Middleware
      def parse(body)
        return if body.blank?
        json = MultiJson.load(body, symbolize_keys: true)
        { data: json }
      end
    end
  end
end
