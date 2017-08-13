require "test_helper"

module TrelloFlow
  class BranchTest < Minitest::Test
    def test_open_pull_request_without_card
      stub_cli
      stub_repo "git@github.com:balvig/trello_flow.git"

      expect_pr(
        repo: "balvig/trello_flow",
        from: "onesky.update-translations.master",
        to: "master",
        title: "",
        body: ""
      )

      Branch.new("onesky.update-translations.master").open_pull_request
    end
  end
end
