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
        #Trello.configure do |config|
        #config.developer_public_key = public_key
        #config.member_token = member_token
        #end
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
        Trello.open_public_key_url
        save :public_key, Cli.ask("Input Developer API key")
      end

      def configure_member_token
        Trello.open_authorization_url key: public_key
        save :member_token, Cli.ask("Input member token")
      end

      def save(key, value)
        data[key] = value
        File.new(PATH, "w") unless File.exists?(PATH)
        File.open(PATH, "w") { |f| f.write(data.to_yaml) }
        value
      end
  end
end
