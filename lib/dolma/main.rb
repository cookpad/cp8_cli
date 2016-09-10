module Dolma
  class Main
    def initialize(config = Config.new)
      @config = config
    end

    def start(input)
      card = Api::Card.find_by_url(input) #|| Table.new(Api::Card.for(config.username)).pick
      checklist = card.find_or_create_checklist
      item = checklist.select_or_create_item
      item.assign(config.username)
      Branch.from_item(item).checkout
    end

    def open
      Branch.current.open_trello_card
    end

    def finish
      branch = Branch.current
      branch.push
      branch.open_pull_request
      branch.complete_current_item
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
