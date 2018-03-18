require "test_helper"

module Cp8Cli
  class MainTest < Minitest::Test
    def setup
      stub_shell
      stub_request(:get, /api\.rubygems\.org/).to_return_json({})
    end

    def test_start_adhoc_story
      pr_endpoint = stub_github(:post, "/repos/balvig/cp8_cli/pulls").
        with(body: { base: "master", head: "jb.fix-bug.master", title: "[WIP] Fix bug" })
      stub_branch("master")
      stub_github_user("John Bobson")
      stub_repo("git@github.com:balvig/cp8_cli.git")

      expect_checkout("jb.fix-bug.master")
      expect_commit("Started: Fix bug")
      expect_push("jb.fix-bug.master")

      cli.start("Fix bug")

      shell.verify
      assert_requested pr_endpoint
    end

    def test_start_with_blank_name
      expect_error("No name/url provided")

      cli.start(nil)
    end

    def test_start_github_issue
      issue_endpoint = stub_github(:get, "/repos/balvig/cp8_cli/issues/ISSUE_NUMBER").to_return_json(github_issue)
      user_endpoint = stub_github(:get, "/user").to_return_json(github_user)
      assign_endpoint = stub_github(:post, "/repos/balvig/cp8_cli/issues/ISSUE_NUMBER/assignees").
        with(body: { assignees: ["GITHUB_USER"] })
      stub_branch("master")
      stub_github_user("John Bobson")

      expect_checkout("jb.issue-title.master.balvig/cp8_cli#ISSUE_NUMBER")

      cli.start("https://github.com/balvig/cp8_cli/issues/ISSUE_NUMBER")

      shell.verify

      assert_requested issue_endpoint
      assert_requested user_endpoint
      assert_requested assign_endpoint
    end

    def test_start_release_branch
      stub_github(:get, "/repos/balvig/cp8_cli/issues/ISSUE_NUMBER").to_return_json(github_issue)
      stub_github(:get, "/user").to_return_json(github_user)
      stub_github(:post, "/repos/balvig/cp8_cli/issues/ISSUE_NUMBER/assignees")
      stub_branch("release-branch")
      stub_github_user("John Bobson")

      expect_checkout("jb.issue-title.release-branch.balvig/cp8_cli#ISSUE_NUMBER")

      cli.start("https://github.com/balvig/cp8_cli/issues/ISSUE_NUMBER")

      shell.verify
    end

    def test_open_master
      stub_branch("master")

      expect_error("Not currently on story branch")

      cli.open

      shell.verify
    end

    def test_open_issue
      stub_github(:get, "/repos/balvig/cp8_cli/issues/ISSUE_NUMBER").to_return_json(github_issue)
      stub_branch("jb.issue-title.master.balvig/cp8_cli#ISSUE_NUMBER")

      expect_open_url("https://github.com/balvig/cp8_cli/issues/ISSUE_NUMBER")

      cli.open

      shell.verify
    end

    def test_submit
      issue_endpoint = stub_github(:get, "/repos/balvig/cp8_cli/issues/ISSUE_NUMBER").to_return_json(github_issue)
      stub_branch("jb.issue-title.master.balvig/cp8_cli#ISSUE_NUMBER")
      stub_repo("git@github.com:balvig/cp8_cli.git")

      expect_push("jb.issue-title.master.balvig/cp8_cli#ISSUE_NUMBER")
      expect_pr(
        repo: "balvig/cp8_cli",
        from: "jb.issue-title.master.balvig/cp8_cli#ISSUE_NUMBER",
        to: "master",
        title: "ISSUE TITLE",
        body: "Closes balvig/cp8_cli#ISSUE_NUMBER\n\n_Release note: ISSUE TITLE_",
        expand: 1
      )

      cli.submit

      shell.verify
      assert_requested issue_endpoint
    end

    def test_submit_wip
      stub_github(:get, "/repos/balvig/cp8_cli/issues/ISSUE_NUMBER").to_return_json(github_issue)
      stub_branch("jb.issue-title.master.balvig/cp8_cli#ISSUE_NUMBER")
      stub_repo("git@github.com:balvig/cp8_cli.git")

      expect_push("jb.issue-title.master.balvig/cp8_cli#ISSUE_NUMBER")
      expect_pr(
        repo: "balvig/cp8_cli",
        from: "jb.issue-title.master.balvig/cp8_cli#ISSUE_NUMBER",
        to: "master",
        title: "[WIP] ISSUE TITLE",
        body: "Closes balvig/cp8_cli#ISSUE_NUMBER\n\n_Release note: ISSUE TITLE_",
        expand: 1
      )

      cli.submit(wip: true)

      shell.verify
    end


    def test_submit_plain_branch
      stub_branch("fix-this")
      stub_repo("git@github.com:balvig/cp8_cli.git")

      expect_push("fix-this")
      expect_pr(
        repo: "balvig/cp8_cli",
        from: "fix-this",
        to: "master",
        expand: 1
      )

      cli.submit

      shell.verify
    end

    def test_ci
      stub_branch("jb.issue-title.master.balvig/cp8_cli#ISSUE_NUMBER")
      stub_repo("git@github.com:balvig/cp8_cli.git")

      expect_open_url("https://circleci.com/gh/balvig/cp8_cli/tree/jb.issue-title.master.balvig%2Fcp8_cli%23ISSUE_NUMBER")

      cli.ci

      shell.verify
    end

    def test_suggest
      stub_branch("jb.card-name.master.CARD_SHORT_LINK")
      stub_repo("git@github.com:balvig/cp8_cli.git")

      expect_checkout("suggestion-HEX")
      expect_push("suggestion-HEX")
      expect_pr(
        repo: "balvig/cp8_cli",
        from: "suggestion-HEX",
        to: "jb.card-name.master.CARD_SHORT_LINK"
      )
      expect_checkout("jb.card-name.master.CARD_SHORT_LINK")
      expect_reset("jb.card-name.master.CARD_SHORT_LINK")

      SecureRandom.stub :hex, "HEX" do
        cli.suggest
      end

      shell.verify

    end

    private

      def label
        { id: "LABEL_ID", name: "LABEL NAME" }
      end

      def github_issue
        { number: "ISSUE_NUMBER", title: "ISSUE TITLE", html_url: "https://github.com/balvig/cp8_cli/issues/ISSUE_NUMBER" }
      end

      def github_user
        { login: "GITHUB_USER" }
      end

      def cli
        @_cli ||= Main.new global_config
      end

      def global_config
        GlobalConfig.new(key: "PUBLIC_KEY", github_token: "GITHUB_TOKEN")
      end
  end
end
