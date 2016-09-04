require "dolma/api/base"

module Dolma
  class Config
    PATH = ENV["HOME"] + "/.dolma"

    def initialize(data = load_data || {})
      @data = data
      Api::Base.configure(key: key, token: token)
    end

    def username
      "balvig"
    end

    private

      attr_reader :data

      def load_data
        YAML.load(File.read(PATH))
      rescue
        false
      end

      def key
        @_key ||= data[:key] || configure_key
      end

      def token
        @_token ||= data[:token] || configure_token
      end

      def configure_key
        Cli.ask "Press enter to setup Trello for this project (will open public key url)"
        Cli.open_url "https://trello.com/app-key"
        save :key, Cli.ask("Input Developer API key")
      end

      def configure_token
        Cli.open_url authorize_url(key)
        save :token, Cli.ask("Input member token")
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
