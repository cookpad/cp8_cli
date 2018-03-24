module Cp8Cli
  class BranchName
    def initialize(user:, short_link:)
      @user = user
      @short_link = short_link
    end

    def to_s
      "#{prefix}/#{short_link}"
    end

    private

      attr_reader :user, :short_link

      def prefix
        user.initials.downcase
      end
  end
end
