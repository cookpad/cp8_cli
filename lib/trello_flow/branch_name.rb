module TrelloFlow
  class BranchName
    def initialize(user:, target:, card:)
      @user = user
      @target = target
      @card = card
    end

    def to_s
      parts.join(".")
    end

    private

      attr_reader :user, :target, :card

      def parts
        parts = []
        parts << user.initials.downcase
        parts << title
        parts << target
        parts << card.short_link
        parts
      end

      def title
        card.name.parameterize[0..50]
      end
  end
end
