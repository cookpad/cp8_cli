require "multi_json"

module Dolma
  module Api
    class JSONParser < Faraday::Response::Middleware
      def parse(body)
        return if body.blank?
        json = MultiJson.load(body, symbolize_keys: true)
        { data: json }
      end
    end
  end
end
