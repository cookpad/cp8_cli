module TrelloFlow
  class Main
    def initialize(config = Config.new)
      @config = config
    end

    def start(name)
      if name.to_s.start_with?("http")
        card = Api::Card.find_by_url(name)
        name = nil
      else
        card = find_or_create_card(name)
      end

      checklist = card.find_or_create_checklist
      item = checklist.select_or_create_item(name)
      item.assign(username)
      Branch.from_item(item).checkout
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

      def find_or_create_card(name)
        if Cli.ask("(n)ew or (e)xisting card?") == "n"
          create_new_card(name)
        else
          pick_existing_card
        end
      end

      def create_new_card(name)
        board = Table.pick(Api::Member.current.boards.active)
        list = Table.pick(board.lists)
        list.cards.create name: Cli.ask("Input card title [#{name}]:").presence || name
      end

      def pick_existing_card
        Table.pick Api::Card.for(username)
      end

      def username
        @_username ||= Api::Member.current.username
      end
  end
end
