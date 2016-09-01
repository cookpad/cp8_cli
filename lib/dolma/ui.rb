module Dolma
  class UI
    def initialize(url)
      @config = Config.new
      @url = url || ask_for_url
    end

    def run
      card = Card.find_by_url(url) || error("Card not found")
      checklist = card.find_or_create_checklist
      item = checklist.select_or_create_item(card)
      item.assign(card, checklist, config.username)
      branch = Branch.from_item(item).to_s
      say "Create branch '#{branch}'"
    end

    private

      attr_reader :config, :url

      def ask_for_url
        `open https://trello.com/#{config.username}/cards`
        ask "Input card URL:"
      end

      def error(*msg)
        super
        exit(false)
      end
  end
end
