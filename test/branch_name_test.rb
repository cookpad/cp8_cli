require "test_helper"

module Cp8Cli
  class BranchNameTest < Minitest::Test
    def setup
      stub_shell
    end

    def test_to_s
      stub_github_user("Doug Adams")
      user = CurrentUser.new
      story = Minitest::Mock.new
      story.expect :title, "Fix Bug"
      name = BranchName.new(user: user, story: story).to_s

      assert_equal "da/fix-bug", name
    end
  end
end
