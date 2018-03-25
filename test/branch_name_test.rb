require "test_helper"

module Cp8Cli
  class BranchNameTest < Minitest::Test
    def setup
      stub_shell
    end

    def test_to_s
      stub_github_user("Doug Adams")
      user = CurrentUser.new
      name = BranchName.new(user: user, short_link: "cookpad/cp-8#1234").to_s

      assert_equal "da/cookpad/cp-8#1234", name
    end
  end
end
