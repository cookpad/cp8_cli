require "active_support/core_ext/string"

module Cp8Cli
  class CurrentUser
    include Github::Api::Client

    def initials
      raise_error("please setup your user.name using git config user.name MyName") unless git_user_name
      git_user_name.parameterize(separator: " ").split.map(&:first).join
    end

    def github_login
      github_user.login
    end

    private

      def git_user_name
        @_git_user_name ||= Command.read("git config user.name")
      end

      def github_user
        @_github_user ||= client.user
      end

      def raise_error(error)
        Command.say("Error running: #{error}")
      end
  end
end
