require "trello_flow/api/base"

module TrelloFlow
  class Config
    PATH = ENV["HOME"] + "/.trello_flow"

    def initialize(data = load_data || {})
      @data = data
      Api::Base.configure(key: key, token: token)
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
        "https://trello.com/1/authorize?key=#{key}&name=Trello-Flow&scope=read,write,account&expiration=never&response_type=token"
      end
  end
end
