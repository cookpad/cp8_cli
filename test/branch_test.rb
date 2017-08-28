require "test_helper"

module Cp8Cli
  class BranchTest < Minitest::Test
    def test_open_pull_request_without_card
      stub_shell
      stub_repo "git@github.com:balvig/cp8_cli.git"

      expect_pr(
        repo: "balvig/cp8_cli",
        from: "onesky.update-translations.master",
        to: "master",
        title: "",
        body: ""
      )

      Branch.new("onesky.update-translations.master").open_pull_request
    end
  end
end
