require "multi_json"

module Dolma
  class JSONParser < Faraday::Response::Middleware
    def parse(body)
      return if body.blank?
      json = MultiJson.load(body, symbolize_keys: true)
      {
        data: json,
        #metadata: {},
        #errors: []
      }
    rescue MultiJson::ParseError
      raise "Failed to parse #{body}"
    end
  end
end
