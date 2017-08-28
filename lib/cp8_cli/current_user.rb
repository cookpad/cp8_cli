module Cp8Cli
  class CurrentUser
    def initials
      trello_user.initials # TODO: What about for GitHub only usage?
    end

    def trello_id
      trello_user.id
    end

    def github_login
      github_user.login
    end

    private

      def github_user
        @_github_user ||= Github::Base.client.user
      end

      def trello_user
        @_trello_user ||= Trello::Member.current
      end
  end
end
