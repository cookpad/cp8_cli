require "cp8_cli/config_store"

module Cp8Cli
  class GlobalConfig
    PATH = ENV["HOME"] + "/.trello_flow"

    def initialize(store = nil)
      @store = store || ConfigStore.new(PATH)
    end

    def github_token
      @_github_token ||= store[:github_token] || env_github_token || configure_github_token
    end

    private

      attr_reader :store

      def env_github_token
        ENV["OCTOKIT_ACCESS_TOKEN"]
      end

      def configure_github_token
        store.save(
          :github_token,
          Command.ask("Input GitHub access token with repo access scope (https://github.com/settings/tokens):")
        )
      end
  end
end
