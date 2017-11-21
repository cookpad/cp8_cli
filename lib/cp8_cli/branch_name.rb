module Cp8Cli
  class BranchName
    def initialize(user:, target:, title:, short_link: nil)
      @user = user
      @target = target
      @title = title
      @short_link = short_link
    end

    def to_s
      parts.join(".")
    end

    private

      attr_reader :user, :target, :title, :short_link

      def parts
        parts = []
        parts << user.initials.downcase
        parts << title.parameterize[0..50]
        parts << target
        parts << short_link
        parts
      end
  end
end
