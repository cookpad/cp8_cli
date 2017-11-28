require "test_helper"

module Cp8Cli
  class MainTest < Minitest::Test
    def setup
      stub_shell
      stub_trello(:get, "/tokens/MEMBER_TOKEN/member").to_return_json(member)
      stub_request(:get, /api\.rubygems\.org/).to_return_json({})
    end

    def test_start_from_trello_url
      card_endpoint = stub_trello(:get, "/cards/CARD_SHORT_LINK").to_return_json(card)
      board_endpoint = stub_trello(:get, "/boards/BOARD_ID").to_return_json(board)
      lists_endpoint = stub_trello(:get, "/boards/BOARD_ID/lists").to_return_json([backlog, started, finished])
      move_to_list_endpoint = stub_trello(:put, "/cards/CARD_ID/idList").with(body: { value: "STARTED_LIST_ID" })
      add_member_endpoint = stub_trello(:post, "/cards/CARD_ID/members").with(body: { value: "MEMBER_ID" })
      stub_branch("master")
      stub_github_user("John Bobson")

      expect_checkout("jb.card-name.master.CARD_SHORT_LINK")

      cli.start(card_url)

      shell.verify
      assert_requested card_endpoint
      assert_requested board_endpoint
      assert_requested lists_endpoint
      assert_requested move_to_list_endpoint
      assert_requested add_member_endpoint
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

    #def test_start_with_blank_name
      #expect_error("No name/url provided")

      #cli.start(nil)
    #end

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

    def test_open_card
      stub_trello(:get, "/cards/CARD_SHORT_LINK").to_return_json(card)
      stub_branch("jb.card-name.master.CARD_SHORT_LINK")

      expect_open_url("https://trello.com/c/CARD_SHORT_LINK/2-trello-flow")

      cli.open

      shell.verify
    end

    def test_submit
      card_endpoint = stub_trello(:get, "/cards/CARD_SHORT_LINK").to_return_json(card)
      stub_branch("jb.card-name.master.CARD_SHORT_LINK")
      stub_repo("git@github.com:balvig/cp8_cli.git")

      expect_push("jb.card-name.master.CARD_SHORT_LINK")
      expect_pr(
        repo: "balvig/cp8_cli",
        from: "jb.card-name.master.CARD_SHORT_LINK",
        to: "master",
        title: "CARD NAME [Delivers #CARD_SHORT_LINK]",
        body: "Trello: #{card_short_url}\n\n_Release note: CARD NAME_",
        expand: 1
      )

      cli.submit

      shell.verify
      assert_requested card_endpoint
    end

    def test_submit_wip
      stub_trello(:get, "/cards/CARD_SHORT_LINK").to_return_json(card)
      stub_branch("jb.card-name.master.CARD_SHORT_LINK")
      stub_repo("git@github.com:balvig/cp8_cli.git")

      expect_push("jb.card-name.master.CARD_SHORT_LINK")
      expect_pr(
        repo: "balvig/cp8_cli",
        from: "jb.card-name.master.CARD_SHORT_LINK",
        to: "master",
        title: "[WIP] CARD NAME [Delivers #CARD_SHORT_LINK]",
        body: "Trello: #{card_short_url}\n\n_Release note: CARD NAME_",
        expand: 1
      )

      cli.submit(wip: true)

      shell.verify
    end

    def test_submit_github_issue
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

    def test_inexistent_card
      stub_trello(:get, "/cards/CARD_SHORT_LINK").to_return(invalid_card_id)

      expect_error("invalid id")

      cli.start(card_url)

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

      def card_short_link
        "CARD_SHORT_LINK"
      end

      def card_short_url
        "https://trello.com/c/#{card_short_link}"
      end

      def card_url
        "#{card_short_url}/2-trello-flow"
      end

      def board_url
        "https://trello.com/b/qdC0CNy0/2-trello-flow-board"
      end

      def member
        { id: "MEMBER_ID", username: "balvig", initials: "JB" }
      end

      def board
        { name: "BOARD NAME", id: "BOARD_ID", url: board_url }
      end

      def backlog
        { id: "BACKLOG_LIST_ID" }
      end

      def started
        { id: "STARTED_LIST_ID" }
      end

      def finished
        { id: "FINISHED_LIST_ID" }
      end

      def card
        { id: "CARD_ID", name: "CARD NAME", idBoard: "BOARD_ID", url: card_url, shortUrl: card_short_url }
      end

      def label
        { id: "LABEL_ID", name: "LABEL NAME" }
      end

      def github_issue
        { number: "ISSUE_NUMBER", title: "ISSUE TITLE"}
      end

      def github_user
        { login: "GITHUB_USER" }
      end

      def invalid_token
        { status: 400, body: "invalid token" }
      end

      def invalid_card_id
        { status: 302, body: "invalid id" }
      end

      def cli
        @_cli ||= Main.new global_config
      end

      def global_config
        GlobalConfig.new(key: "PUBLIC_KEY", token: "MEMBER_TOKEN", github_token: "GITHUB_TOKEN")
      end
  end
end
