require "test_helper"

module Cp8Cli
  module Github
    class ParsedUrlTest < Minitest::Test
      def test_github_issue_with_anchor
        url = ParsedUrl.new("https://github.com/balvig/cp8_cli/issues/ISSUE_NUMBER#pullrequestreview-62945399")

        assert_equal "ISSUE_NUMBER", url.number
        assert_equal "balvig/cp8_cli", url.repo
      end
    end
  end
end
