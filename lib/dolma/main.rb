module Dolma
  class Main
    def initialize
      @config = Config.new
    end

    def start
      url = ARGV.first || ask_for_url
      card = Card.find_by_url(url) || Cli.error("Card not found")
      checklist = card.find_or_create_checklist
      item = checklist.select_or_create_item(card)
      item.assign(card, checklist, config.username)
      Branch.from_item(item).checkout
    end

    def finish
      Branch.current.push
      Branch.current.open_pull_request
    end

    def cleanup
      Cleanup.new(Branch.current.target).run
    end

    private

      attr_reader :config

      def ask_for_url
        Cli.open "https://trello.com/#{config.username}/cards"
        Cli.ask "Input card URL:"
      end
  end
end
