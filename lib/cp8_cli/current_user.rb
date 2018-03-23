require "active_support/core_ext/string"

module Cp8Cli
  class CurrentUser
    def initials
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
        @_github_user ||= Github::Base.client.user
      end
  end
end
