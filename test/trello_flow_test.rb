require "test_helper"

module TrelloFlow
  class TrelloFlowTest < Minitest::Test
    def setup
      Cli.client = cli
      stub_trello(:get, "/tokens/MEMBER_TOKEN/member").to_return_json(member)
    end

    def test_git_start_from_url
      card_endpoint = stub_trello(:get, "/cards/CARD_SHORT_LINK").to_return_json(card)
      board_endpoint = stub_trello(:get, "/boards/BOARD_ID").to_return_json(board)
      lists_endpoint = stub_trello(:get, "/boards/BOARD_ID/lists").to_return_json([backlog, started, finished])
      move_to_list_endpoint = stub_trello(:put, "/cards/CARD_ID/idList").with(body: { value: "STARTED_LIST_ID" })
      add_member_endpoint = stub_trello(:post, "/cards/CARD_ID/members").with(body: { value: "MEMBER_ID" })

      cli.expect :read, "master", ["git rev-parse --abbrev-ref HEAD"]
      cli.expect :run, nil, ["git checkout jb.card-name.master.CARD_SHORT_LINK >/dev/null 2>&1 || git checkout -b jb.card-name.master.CARD_SHORT_LINK"]

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

      cli.expect :table, nil, [Array] # Pick label
      cli.expect :ask, 1, ["Add label:", Integer]
      cli.expect :read, "master", ["git rev-parse --abbrev-ref HEAD"]
      cli.expect :run, nil, ["git checkout jb.card-name.master.CARD_SHORT_LINK >/dev/null 2>&1 || git checkout -b jb.card-name.master.CARD_SHORT_LINK"]

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

      cli.expect :table, nil, [Array] # Pick column
      cli.expect :ask, 1, ["Pick one:", Integer]
      cli.expect :read, "master", ["git rev-parse --abbrev-ref HEAD"]
      cli.expect :run, nil, ["git checkout jb.card-name.master.CARD_SHORT_LINK >/dev/null 2>&1 || git checkout -b jb.card-name.master.CARD_SHORT_LINK"]

      trello_flow.start(nil)

      cli.verify
      assert_requested lists_endpoint, times: 2
      assert_requested cards_endpoint
      assert_requested board_endpoint, times: 2
      assert_requested move_to_list_endpoint
      assert_requested add_member_endpoint
    end

    def test_git_open_master
      board_endpoint = stub_trello(:get, "/boards/BOARD_ID").to_return_json(board)

      cli.expect :read, "master", ["git rev-parse --abbrev-ref HEAD"]
      cli.expect :open_url, nil, [board_url]

      trello_flow.open

      cli.verify
      assert_requested board_endpoint
    end

    def test_git_open_card
      stub_trello(:get, "/cards/CARD_SHORT_LINK").to_return_json(card)

      cli.expect :read, "jb.card-name.master.CARD_SHORT_LINK", ["git rev-parse --abbrev-ref HEAD"]
      cli.expect :open_url, nil, ["https://trello.com/c/CARD_SHORT_LINK/2-trello-flow"]

      trello_flow.open
      cli.verify
    end

    def test_git_finish
      card_endpoint = stub_trello(:get, "/cards/CARD_SHORT_LINK").to_return_json(card)

      cli.expect :read, "jb.card-name.master.CARD_SHORT_LINK", ["git rev-parse --abbrev-ref HEAD"]
      cli.expect :run, nil, ["git push origin jb.card-name.master.CARD_SHORT_LINK -u"]
      cli.expect :read, "git@github.com:balvig/trello_flow.git", ["git config --get remote.origin.url"]
      cli.expect :open_url, nil, ["https://github.com/balvig/trello_flow/compare/master...jb.card-name.master.CARD_SHORT_LINK?expand=1&title=CARD%20NAME%20[Delivers%20%23CARD_SHORT_LINK]&body=Trello:%20#{card_short_url}"]

      trello_flow.finish

      cli.verify
      assert_requested card_endpoint
    end

    def test_git_finish_with_backwards_compatibility
      stub_trello(:get, "/cards/CARD_SHORT_LINK").to_return_json(card)

      cli.expect :read, "master.card-name.CARD_SHORT_LINK", ["git rev-parse --abbrev-ref HEAD"]
      cli.expect :run, nil, ["git push origin master.card-name.CARD_SHORT_LINK -u"]
      cli.expect :read, "git@github.com:balvig/trello_flow.git", ["git config --get remote.origin.url"]
      cli.expect :open_url, nil, ["https://github.com/balvig/trello_flow/compare/master...master.card-name.CARD_SHORT_LINK?expand=1&title=CARD%20NAME%20[Delivers%20%23CARD_SHORT_LINK]&body=Trello:%20#{card_short_url}"]

      trello_flow.finish

      cli.verify
    end

    def test_finish_wip
      stub_trello(:get, "/cards/CARD_SHORT_LINK").to_return_json(card)

      cli.expect :read, "jb.card-name.master.CARD_SHORT_LINK", ["git rev-parse --abbrev-ref HEAD"]
      cli.expect :run, nil, ["git push origin jb.card-name.master.CARD_SHORT_LINK -u"]
      cli.expect :read, "git@github.com:balvig/trello_flow.git", ["git config --get remote.origin.url"]
      cli.expect :open_url, nil, ["https://github.com/balvig/trello_flow/compare/master...jb.card-name.master.CARD_SHORT_LINK?expand=1&title=[WIP]%20CARD%20NAME%20[Delivers%20%23CARD_SHORT_LINK]&body=Trello:%20#{card_short_url}"]

      trello_flow.finish(wip: true)

      cli.verify
    end

    def test_wrong_credentials
      stub_trello(:get, "/boards/BOARD_ID").to_return(invalid_token)
      cli.expect :error, nil, ["invalid token"]
      trello_flow.start(nil)
      cli.verify
    end

    def test_inexistent_card
      stub_trello(:get, "/cards/CARD_SHORT_LINK").to_return(invalid_card_id)
      cli.expect :error, nil, ["invalid id"]
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

      def cli
        @_cli ||= Minitest::Mock.new
      end

      def trello_flow
        @_trello_flow ||= Main.new GlobalConfig.new(key: "PUBLIC_KEY", token: "MEMBER_TOKEN"), LocalConfig.new(board_id: "BOARD_ID")
      end
  end
end
