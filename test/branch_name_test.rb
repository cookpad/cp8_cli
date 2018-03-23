require "test_helper"

module Cp8Cli
  class BranchNameTest < Minitest::Test
    def test_branch_name_for_story
      user = CurrentUser.new
      name = BranchName.new(user: user, branch_identifier: "cookpad/cp-8#1234").to_s

      assert_equal "jb/cookpad/cp-8#1234", name
    end
  end
end
