module Dolma
  class Main
    def initialize(config = Config.new)
      @config = config
    end

    def start(input)
      if input.to_s.start_with?("http")
        start_with_url(input)
      elsif input.present?
        start_new_item(input)
      else
        start_blank
      end
    end

    def open
      Branch.current.open_trello(config.username)
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

      def start_with_url(url)
        card = Api::Card.find_by_url(url)
        checklist = card.find_or_create_checklist
        item = checklist.select_or_create_item
        item.assign(config.username)
        Branch.from_item(item).checkout
      end

      def start_new_item(name)
        card = Table.new(Api::Card.for(config.username)).pick
        checklist = card.find_or_create_checklist
        item = checklist.add_item(name)
        item.assign(config.username)
        Branch.from_item(item).checkout
      end

      def start_blank
        card = Table.new(Api::Card.for(config.username)).pick
        checklist = card.find_or_create_checklist
        item = checklist.select_or_create_item
        item.assign(config.username)
        Branch.from_item(item).checkout
      end

      attr_reader :config
  end
end
