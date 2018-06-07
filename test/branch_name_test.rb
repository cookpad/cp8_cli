require "test_helper"
# changes
# another change

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

      expect_question "Branch name: da/", default: "fix-bug"

      BranchName.new(user: user, story: story).to_s
    end
  end
end
