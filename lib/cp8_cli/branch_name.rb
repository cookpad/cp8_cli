module Cp8Cli
  class BranchName
    def initialize(user:, story:)
      @user = user
      @title = story.title.parameterize[0..50]
    end

    def to_s
      "#{prefix}/#{title}"
    end

    private

      attr_reader :user, :title

      def prefix
        user.initials.downcase
      end
  end
end
