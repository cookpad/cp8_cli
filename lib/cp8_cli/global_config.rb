require "cp8_cli/config_store"

module Cp8Cli
  class GlobalConfig
    LEGACY_PATH = ENV["HOME"] + "/.trello_flow"
    PATH = ENV["HOME"] + "/.cp8_cli"

    def initialize(store = nil)
      @store = store || initialize_store
    end

    def github_token
      @_github_token ||= store[:github_token] || env_github_token || configure_github_token
    end

    private

      attr_reader :store

      def initialize_store
        migrate_legacy_store if uses_legacy_store?

        default_store
      end

      def uses_legacy_store?
        legacy_store.exist?
      end

      def migrate_legacy_store
        Command.say("#{LEGACY_PATH} was deprecated, moving to #{PATH}")
        legacy_store.move_to(PATH)
      end

      def default_store
        @_default_store ||= ConfigStore.new(PATH)
      end

      def legacy_store
        @_legacy_store ||= ConfigStore.new(LEGACY_PATH)
      end

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
