module TrelloFlow
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
      Branch.current.open_trello(username)
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
        item.assign(username)
        Branch.from_item(item).checkout
      end

      def start_blank
        choice = Cli.ask("(n)ew or (e)xisting card?")
        if choice == "n"
          card = start_new_card
        else
          card = start_existing_card
        end

        checklist = card.find_or_create_checklist
        item = checklist.select_or_create_item
        item.assign(username)
        Branch.from_item(item).checkout
      end

      def start_new_card
        board = Table.pick(Api::Member.current.boards.active)
        list = Table.pick(board.lists)
        list.cards.create name: Cli.ask("Input card title")
      end

      def start_existing_card
        Table.pick Api::Card.for(username)
      end

      def start_new_item(name)
        card = Table.pick(Api::Card.for(username))
        checklist = card.find_or_create_checklist
        item = checklist.add_item(name)
        item.assign(username)
        Branch.from_item(item).checkout
      end

      def username
        @_username ||= Api::Member.current.username
      end
  end
end
