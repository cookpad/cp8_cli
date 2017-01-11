require "trello_flow/local_config"
require "trello_flow/global_config"

module TrelloFlow
  class Main
    def initialize(global_config = GlobalConfig.new, local_config = LocalConfig.new)
      Api::Base.configure(key: global_config.key, token: global_config.token)
      @local_config = local_config
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
    end

    def cleanup
      Cleanup.new(Branch.current.target).run
    end

    private

      attr_reader :local_config

      def board
        @_board ||= local_config.board
      end

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
        card = board.lists.backlog.cards.create name: name
        label = Table.pick board.labels, caption: "Add label:"
        card.add_label(label) if label
        card
      end

      def pick_existing_card
        Table.pick board.lists.backlog.cards
      end

      def current_user
        @_current_user ||= Api::Member.current
      end
  end
end
