module TrelloFlow
  class Main
    def initialize(config = Config.new)
      Api::Base.configure(key: config.key, token: config.token)
    end

    def start(name)
      card = create_or_pick_card(name)
      card.add_member(current_user)
      card.start
      Branch.from_card(card).checkout
    end

    def open
      Branch.current.open_trello(current_user)
    end

    def finish
      branch = Branch.current
      branch.push
      branch.open_pull_request
      branch.finish_current_card
    end

    def cleanup
      Cleanup.new(Branch.current.target).run
    end

    private

      def create_or_pick_card(name)
        if name.to_s.start_with?("http")
          Api::Card.find_by_url(name)
        elsif name.present?
          create_new_card(name)
        else
          pick_existing_card
        end
      end

      def create_new_card(name)
        board = Table.pick(current_user.boards.active)
        board.lists.backlog.cards.create name: name
      end

      def pick_existing_card
        board = Table.pick(current_user.boards.active)
        Table.pick board.lists.backlog.cards
      end

      def current_user
        @_current_user ||= Api::Member.current
      end
  end
end
