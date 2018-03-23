require "test_helper"

module Cp8Cli
  class BranchNameTest < Minitest::Test
    def setup
      stub_shell
    end

    def test_branch_name_for_story
      stub_github_user("Doug Adams")
      user = CurrentUser.new
      name = BranchName.new(user: user, branch_identifier: "cookpad/cp-8#1234").to_s

      assert_equal "da/cookpad/cp-8#1234", name
    end
  end
end
