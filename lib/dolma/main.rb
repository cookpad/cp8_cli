module Dolma
  class Main
    def initialize(url)
      @config = Config.new
      @url = url || ask_for_url
    end

    def run
      card = Card.find_by_url(url) || error("Card not found")
      checklist = card.find_or_create_checklist
      item = checklist.select_or_create_item(card)
      item.assign(card, checklist, config.username)
      Branch.from_item(item).checkout
    end

    private

      attr_reader :config, :url

      def ask_for_url
        Cli.run "open https://trello.com/#{config.username}/cards"
        Cli.ask "Input card URL:"
      end
  end
end
