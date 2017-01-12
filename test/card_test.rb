require "test_helper"

module TrelloFlow
  class CardTest < Minitest::Test
    def setup
      Api::Base.configure(key: "PUBLIC_KEY", token: "MEMBER_TOKEN")
    end

    def test_attach
      attach_endpoint = stub_trello(:post, "/cards/CARD_ID/attachments").with(body: { url: "https://github.com/balvig/cp-8" })

      card = Api::Card.new(id: "CARD_ID")
      card.attach(url: "https://github.com/balvig/cp-8")

      assert_requested attach_endpoint
    end
  end
end
