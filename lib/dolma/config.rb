require "spyke"
require "dolma/json_parser"

module Dolma
  class Config
    PATH = ENV["HOME"] + "/.dolma"

    def initialize(data = load_data || {})
      @data = data
      configure_api
    end

    def username
      "balvig"
    end

    private

      attr_reader :data

      def configure_api
        Spyke::Base.connection = Faraday.new(url: "https://api.trello.com/1", params: { key: public_key, token: member_token }) do |c|
          c.request   :json
          c.use       JSONParser
          c.adapter   Faraday.default_adapter
        end
      end

      def load_data
        YAML.load(File.read(PATH))
      rescue
        false
      end

      def public_key
        @_public_key ||= data[:public_key] || configure_public_key
      end

      def member_token
        @_member_token ||= data[:member_token] || configure_member_token
      end

      def configure_public_key
        Cli.ask "Press enter to setup Trello for this project (will open public key url)"
        Cli.open_url "https://trello.com/app-key"
        save :public_key, Cli.ask("Input Developer API key")
      end

      def configure_member_token
        Cli.open_url authorize_url(public_key)
        save :member_token, Cli.ask("Input member token")
      end

      def save(key, value)
        data[key] = value
        File.new(PATH, "w") unless File.exists?(PATH)
        File.open(PATH, "w") { |f| f.write(data.to_yaml) }
        value
      end

      def authorize_url(key)
        params = {}
        params[:key] = key
        params[:name] = "Trello-Flow"
        params[:scope] = "read,write,account"
        params[:expiration] = "never"
        params[:response_type] = "token"
        uri = Addressable::URI.parse "https://trello.com/1/authorize"
        uri.query_values = params
        uri
      end
  end
end
