module Cp8Cli
  class BranchName
    SEPARATOR = "/"

    def initialize(user:, story:)
      @user = user
      @story = story
    end

    def to_s
      "#{prefix}#{user_input}"
    end

    private

      attr_reader :user, :story

      def user_input
        Command.ask("Branch name: #{prefix}", default: default)
      end

      def prefix
        user.initials.downcase + SEPARATOR
      end

      def default
        story.title.parameterize[0..50]
      end
  end
end
