require 'test_helper'

module Dolma
  class DolmaTest < Minitest::Test
    def setup
      Cli.client = cli
    end

    def test_git_start
      card_endpoint = stub_trello(:get, "/cards/CARD_ID").to_return_json(card)
      checklists_endpoint = stub_trello(:get, "/cards/CARD_ID/checklists").to_return_json([checklist])
      checklist_endpoint = stub_trello(:get, "/checklists/CHECKLIST_ID").to_return_json(checklist)
      update_item_endpoint = stub_trello(:put, "/cards/CARD_ID/checklist/CHECKLIST_ID/checkItem/ITEM_ID/name").with(body: { value: "ITEM TASK @balvig" })

      cli.expect :title, nil, ["CARD NAME (CHECKLIST NAME)"]
      cli.expect :table, nil, [Array]
      cli.expect :ask, 1, ["Pick one:", Integer]
      cli.expect :read, "master", ["git rev-parse --abbrev-ref HEAD"]
      cli.expect :run, nil, ["git checkout -b master.item-task.CHECKLIST_ID-ITEM_ID"]

      dolma.start(card_url)

      cli.verify
      assert_requested card_endpoint, at_least_times: 1
      assert_requested checklists_endpoint
      assert_requested checklist_endpoint
      assert_requested update_item_endpoint
    end

    #def test_git_start_without_url
      #card_endpoint = stub_trello(:get, "/cards/CARD_ID").to_return_json(card)
      #checklists_endpoint = stub_trello(:get, "/cards/CARD_ID/checklists").to_return_json([checklist])
      #checklist_endpoint = stub_trello(:get, "/checklists/CHECKLIST_ID").to_return_json(checklist)
      #update_item_endpoint = stub_trello(:put, "/cards/CARD_ID/checklist/CHECKLIST_ID/checkItem/ITEM_ID/name").with(body: { value: "ITEM TASK @balvig" })

      #cli.expect :title, nil, ["CARD NAME (CHECKLIST NAME)"]
      #cli.expect :table, nil, [Array]
      #cli.expect :ask, 1, ["Pick one:", Integer]
      #cli.expect :read, "master", ["git rev-parse --abbrev-ref HEAD"]
      #cli.expect :run, nil, ["git checkout -b master.item-task.CHECKLIST_ID-ITEM_ID"]

      #dolma.start

      #cli.verify
      #assert_requested card_endpoint, at_least_times: 1
      #assert_requested checklists_endpoint
      #assert_requested checklist_endpoint
      #assert_requested update_item_endpoint
    #end

    #def test_git_start_arbitrary_story
      #cli.expect :read, "master", ["git rev-parse --abbrev-ref HEAD"]
      #cli.expect :run, nil, ["git checkout -b master.fix-header-obscuring-body"]

      #dolma.start "Fix header obscuring body"
      #cli.verify
    #end

    def test_git_start_card_with_no_checklists
      card_endpoint = stub_trello(:get, "/cards/CARD_ID").to_return_json(card)
      checklists_endpoint = stub_trello(:get, "/cards/CARD_ID/checklists").to_return_json([])
      create_checklist_endpoint = stub_trello(:post, "/checklists").with(body: { idCard: "CARD_ID", name: "To-Do" }).to_return_json(checklist(items: []))
      checklist_endpoint = stub_trello(:get, "/checklists/CHECKLIST_ID").to_return_json(checklist)
      create_item_endpoint = stub_trello(:post, "/checklists/CHECKLIST_ID/checkItems").with(body: { title: "ITEM TASK" }).to_return_json(item)
      update_item_endpoint = stub_trello(:put, "/cards/CARD_ID/checklist/CHECKLIST_ID/checkItem/ITEM_ID/name").with(body: { value: "ITEM TASK @balvig" })

      cli.expect :say, nil, ["No to-dos found"]
      cli.expect :ask, "ITEM TASK", ["Input to-do [CARD NAME]:"]
      cli.expect :read, "master", ["git rev-parse --abbrev-ref HEAD"]
      cli.expect :run, nil, ["git checkout -b master.item-task.CHECKLIST_ID-ITEM_ID"]

      dolma.start(card_url)

      cli.verify
      assert_requested card_endpoint, at_least_times: 1
      assert_requested checklists_endpoint
      assert_requested create_checklist_endpoint
      assert_requested checklist_endpoint
      assert_requested create_item_endpoint
      assert_requested update_item_endpoint
    end

    def test_git_open
      stub_trello(:get, "/checklists/CHECKLIST_ID/checkItems/ITEM_ID").to_return_json(item)
      stub_trello(:get, "/checklists/CHECKLIST_ID").to_return_json(checklist)
      stub_trello(:get, "/cards/CARD_ID").to_return_json(card)

      cli.expect :read, "master.item-task.CHECKLIST_ID-ITEM_ID", ["git rev-parse --abbrev-ref HEAD"]
      cli.expect :open_url, nil, ["https://trello.com/c/CARD_ID/2-trello-flow"]

      dolma.open
      cli.verify
    end

    def test_git_finish
      item_endpoint = stub_trello(:get, "/checklists/CHECKLIST_ID/checkItems/ITEM_ID").to_return_json(item)

      cli.expect :read, "master.item-task.CHECKLIST_ID-ITEM_ID", ["git rev-parse --abbrev-ref HEAD"]
      cli.expect :run, nil, ["git push origin master.item-task.CHECKLIST_ID-ITEM_ID -u"]
      cli.expect :read, "git@github.com:balvig/dolma.git", ["git config --get remote.origin.url"]
      cli.expect :open_url, nil, ["https://github.com/balvig/dolma/compare/master...master.item-task.CHECKLIST_ID-ITEM_ID?expand=1&title=ITEM%20TASK%20[Delivers%20%23ITEM_ID]"]

      dolma.finish

      cli.verify
      assert_requested item_endpoint
    end

    private

      def card_url
        "https://trello.com/c/CARD_ID/2-trello-flow"
      end

      def card
        { id: "CARD_ID", name: "CARD NAME", shortUrl: card_url }
      end

      def checklist(items: [item, item])
        { id: "CHECKLIST_ID", name: "CHECKLIST NAME", checkItems: items, idCard: "CARD_ID" }
      end

      def item
        { id: "ITEM_ID", name: "ITEM TASK @owner", idChecklist: "CHECKLIST_ID", state: "incomplete" }
      end

      def cli
        @_cli ||= Minitest::Mock.new
      end

      def dolma
        @_dolma ||= Main.new Config.new(key: "PUBLIC_KEY", token: "MEMBER_TOKEN")
      end
  end
end
