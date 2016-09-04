module Dolma
  class Main
    def initialize(config = Config.new)
      @config = config
    end

    def start(url)
      card = Card.find_by_url(url) || ask_for_url
      checklist = card.find_or_create_checklist
      item = checklist.select_or_create_item
      item.assign(config.username)
      Branch.from_item(item).checkout
    end

    def finish
      branch = Branch.current
      branch.push
      branch.open_pull_request
    end

    def cleanup
      Cleanup.new(Branch.current.target).run
    end

    private

      attr_reader :config

      def ask_for_url
        Cli.open_url "https://trello.com/#{config.username}/cards"
        Cli.error("Usage: git start <CARD URL>")
      end
  end
end
