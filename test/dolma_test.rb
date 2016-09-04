require 'test_helper'

module Dolma
  class DolmaTest < Minitest::Test
    def test_git_start
      card_endpoint = stub_trello(:get, "/cards/iYsmSmXA").to_return_json(id: "iYsmSmXA", name: "Trello Flow")
      checklists_endpoint = stub_trello(:get, "/cards/iYsmSmXA/checklists").
        with(query: { filter: "all" }).
        to_return_json([{ id: "CHECKLIST_ID", name: "To-Do", checkItems: [] }])

      dolma.start("https://trello.com/c/iYsmSmXA/2-trello-flow")

      assert_requested card_endpoint
      assert_request checklists_endpoint
    end

    private

      def dolma
        @_dolma ||= Main.new Config.new(public_key: "PUBLIC_KEY", member_token: "MEMBER_TOKEN")
      end
  end
end
