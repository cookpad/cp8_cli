module TrelloFlow
  class BranchName
    def initialize(user:, target:, story:)
      @user = user
      @target = target
      @story = story
    end

    def to_s
      parts.join(".")
    end

    private

      attr_reader :user, :target, :story

      def parts
        parts = []
        parts << user.initials.downcase
        parts << title
        parts << target
        parts << story.short_link
        parts
      end

      def title
        story.title.parameterize[0..50]
      end
  end
end
