module Cp8Cli
  class BranchName
    def initialize(user:, branch_identifier:)
      @user = user
      @branch_identifier = branch_identifier
    end

    def to_s
      "#{prefix}/#{branch_identifier}"
    end

    private

      attr_reader :user, :branch_identifier

      def prefix
        user.initials.downcase
      end
  end
end
