require "test_helper"

module TrelloFlow
  module Github
    class IssueTest < Minitest::Test
      def test_find_by_url
        issue = Issue.find_by_url("https://github.com/balvig/trello_flow/pull/14")

        assert_equal "add cp8 binary", issue.name
      end
    end
  end
end
