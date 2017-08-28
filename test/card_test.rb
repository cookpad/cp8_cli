require "test_helper"

module Cp8Cli
  class CardTest < Minitest::Test
    def setup
      Trello::Base.configure(key: "PUBLIC_KEY", token: "MEMBER_TOKEN")
    end

    def test_attach
      attach_endpoint = stub_trello(:post, "/cards/CARD_ID/attachments").with(body: { url: "https://github.com/balvig/cp-8" })

      card = Trello::Card.new(id: "CARD_ID")
      card.attach(url: "https://github.com/balvig/cp-8")

      assert_requested attach_endpoint
    end
  end
end
