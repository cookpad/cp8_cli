require "cp8_cli/config_store"
require "cp8_cli/trello/base"

module Cp8Cli
  class GlobalConfig
    PATH = ENV["HOME"] + "/.trello_flow"

    def initialize(store = nil)
      @store = store || ConfigStore.new(PATH)
    end

    def trello_key
      @_trello_key ||= store[:key] || configure_trello_key
    end

    def trello_token
      @_trello_token ||= store[:token] || configure_trello_token
    end

    def github_token
      @_github_token ||= store[:github_token] || env_github_token || configure_github_token
    end

    private

      attr_reader :store

      def configure_trello_key
        Command.ask "Press enter to setup Trello for this project (will open public key url)", validate: //
        Command.open_url "https://trello.com/app-key"
        store.save :key, Command.ask("Input Developer API key")
      end

      def configure_trello_token
        Command.open_url trello_authorize_url
        store.save :token, Command.ask("Input member token")
      end

      def env_github_token
        ENV["OCTOKIT_ACCESS_TOKEN"]
      end

      def configure_github_token
        store.save :github_token, Command.ask("Input GitHub token")
      end

      def trello_authorize_url
        "https://trello.com/1/authorize?key=#{trello_key}&name=Trello-Flow&scope=read,write,account&expiration=never&response_type=token"
      end
  end
end
