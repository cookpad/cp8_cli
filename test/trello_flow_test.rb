require "test_helper"

module TrelloFlow
  class TrelloFlowTest < Minitest::Test
    def setup
      stub_cli
      stub_trello(:get, "/tokens/MEMBER_TOKEN/member").to_return_json(member)
      stub_request(:get, /api\.rubygems\.org/)
    end

    def test_git_start_from_url
      card_endpoint = stub_trello(:get, "/cards/CARD_SHORT_LINK").to_return_json(card)
      board_endpoint = stub_trello(:get, "/boards/BOARD_ID").to_return_json(board)
      lists_endpoint = stub_trello(:get, "/boards/BOARD_ID/lists").to_return_json([backlog, started, finished])
      move_to_list_endpoint = stub_trello(:put, "/cards/CARD_ID/idList").with(body: { value: "STARTED_LIST_ID" })
      add_member_endpoint = stub_trello(:post, "/cards/CARD_ID/members").with(body: { value: "MEMBER_ID" })
      stub_branch("master")

      expect_checkout("jb.card-name.master.CARD_SHORT_LINK")

      trello_flow.start(card_url)

      cli.verify
      assert_requested card_endpoint
      assert_requested board_endpoint
      assert_requested lists_endpoint
      assert_requested move_to_list_endpoint
      assert_requested add_member_endpoint
    end

    def test_git_start_with_name
      lists_endpoint = stub_trello(:get, "/boards/BOARD_ID/lists").to_return_json([backlog, started, finished])
      create_card_endpoint = stub_trello(:post, "/lists/BACKLOG_LIST_ID/cards").to_return_json(card)
      board_endpoint = stub_trello(:get, "/boards/BOARD_ID").to_return_json(board)
      labels_endpoint = stub_trello(:get, "/boards/BOARD_ID/labels").to_return_json([label])
      add_label_endpoint = stub_trello(:post, "/cards/CARD_ID/idLabels").with(body: { value: "LABEL_ID" }).to_return_json(["LABEL_ID"])
      move_to_list_endpoint = stub_trello(:put, "/cards/CARD_ID/idList").with(body: { value: "STARTED_LIST_ID" })
      add_member_endpoint = stub_trello(:post, "/cards/CARD_ID/members").with(body: { value: "MEMBER_ID" })
      stub_branch("master")

      cli.expect :table, nil, [Array] # Pick label
      cli.expect :ask, 1, ["Add label:", Integer]
      expect_checkout("jb.card-name.master.CARD_SHORT_LINK")

      trello_flow.start("NEW CARD NAME")

      cli.verify
      assert_requested lists_endpoint, times: 2
      assert_requested create_card_endpoint
      assert_requested board_endpoint, times: 2
      assert_requested labels_endpoint
      assert_requested add_label_endpoint
      assert_requested move_to_list_endpoint
      assert_requested add_member_endpoint
    end

    def test_git_start_with_blank_name
      lists_endpoint = stub_trello(:get, "/boards/BOARD_ID/lists").to_return_json([backlog, started, finished])
      cards_endpoint = stub_trello(:get, "/lists/BACKLOG_LIST_ID/cards").to_return_json([card])
      board_endpoint = stub_trello(:get, "/boards/BOARD_ID").to_return_json(board)
      move_to_list_endpoint = stub_trello(:put, "/cards/CARD_ID/idList").with(body: { value: "STARTED_LIST_ID" })
      add_member_endpoint = stub_trello(:post, "/cards/CARD_ID/members").with(body: { value: "MEMBER_ID" })
      stub_branch("master")

      cli.expect :table, nil, [Array] # Pick column
      cli.expect :ask, 1, ["Pick one:", Integer]
      expect_checkout("jb.card-name.master.CARD_SHORT_LINK")

      trello_flow.start(nil)

      cli.verify
      assert_requested lists_endpoint, times: 2
      assert_requested cards_endpoint
      assert_requested board_endpoint, times: 2
      assert_requested move_to_list_endpoint
      assert_requested add_member_endpoint
    end

    def test_git_start_release_branch
      stub_trello(:get, "/boards/BOARD_ID/lists").to_return_json([backlog, started, finished])
      stub_trello(:get, "/lists/BACKLOG_LIST_ID/cards").to_return_json([card])
      stub_trello(:get, "/boards/BOARD_ID").to_return_json(board)
      stub_trello(:put, "/cards/CARD_ID/idList")
      stub_trello(:post, "/cards/CARD_ID/members")
      stub_branch("release-branch")

      cli.expect :table, nil, [Array] # Pick column
      cli.expect :ask, 1, ["Pick one:", Integer]
      expect_checkout("jb.card-name.release-branch.CARD_SHORT_LINK")

      trello_flow.start(nil)

      cli.verify
    end


    def test_git_open_master
      board_endpoint = stub_trello(:get, "/boards/BOARD_ID").to_return_json(board)
      stub_branch("master")

      expect_open_url(board_url)

      trello_flow.open

      cli.verify
      assert_requested board_endpoint
    end

    def test_git_open_card
      stub_trello(:get, "/cards/CARD_SHORT_LINK").to_return_json(card)
      stub_branch("jb.card-name.master.CARD_SHORT_LINK")

      expect_open_url("https://trello.com/c/CARD_SHORT_LINK/2-trello-flow")

      trello_flow.open

      cli.verify
    end

    def test_git_finish
      card_endpoint = stub_trello(:get, "/cards/CARD_SHORT_LINK").to_return_json(card)
      stub_branch("jb.card-name.master.CARD_SHORT_LINK")
      stub_repo("git@github.com:balvig/trello_flow.git")

      expect_push("jb.card-name.master.CARD_SHORT_LINK")
      expect_pr(
        repo: "balvig/trello_flow",
        from: "jb.card-name.master.CARD_SHORT_LINK",
        to: "master",
        title: "CARD NAME [Delivers #CARD_SHORT_LINK]",
        body: "Trello: #{card_short_url}\n\n_Release note: CARD NAME_"
      )

      trello_flow.finish

      cli.verify
      assert_requested card_endpoint
    end

    def test_finish_wip
      stub_trello(:get, "/cards/CARD_SHORT_LINK").to_return_json(card)
      stub_branch("jb.card-name.master.CARD_SHORT_LINK")
      stub_repo("git@github.com:balvig/trello_flow.git")

      expect_push("jb.card-name.master.CARD_SHORT_LINK")
      expect_pr(
        repo: "balvig/trello_flow",
        from: "jb.card-name.master.CARD_SHORT_LINK",
        to: "master",
        title: "[WIP] CARD NAME [Delivers #CARD_SHORT_LINK]",
        body: "Trello: #{card_short_url}\n\n_Release note: CARD NAME_"
      )

      trello_flow.finish(wip: true)

      cli.verify
    end

    def test_wrong_credentials
      stub_trello(:get, "/boards/BOARD_ID").to_return(invalid_token)

      expect_error("invalid token")

      trello_flow.start(nil)

      cli.verify
    end

    def test_inexistent_card
      stub_trello(:get, "/cards/CARD_SHORT_LINK").to_return(invalid_card_id)

      expect_error("invalid id")

      trello_flow.start(card_url)

      cli.verify
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

      def invalid_token
        { status: 400, body: "invalid token" }
      end

      def invalid_card_id
        { status: 302, body: "invalid id" }
      end

      def trello_flow
        @_trello_flow ||= Main.new GlobalConfig.new(key: "PUBLIC_KEY", token: "MEMBER_TOKEN"), LocalConfig.new(board_id: "BOARD_ID")
      end
  end
end
