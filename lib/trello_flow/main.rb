require "trello_flow/version"
require "trello_flow/local_config"
require "trello_flow/global_config"

module TrelloFlow
  class Main
    def initialize(global_config = GlobalConfig.new, local_config = LocalConfig.new)
      Api::Base.configure(key: global_config.key, token: global_config.token)
      @local_config = local_config
    end

    def start(name)
      Cli.error "Your `trello_flow` version is out of date. Please run `gem update trello_flow`." unless Version.latest?
      card = create_or_pick_card(name)
      card.add_member(current_user)
      card.start
      Branch.from_card(user: current_user, card: card).checkout
    rescue Api::Error => error
      Cli.error(error.message)
    end

    def open
      Branch.current.open_trello(user: current_user, config: local_config)
    end

    def finish(options = {})
      update_master_branch
      branch = Branch.current
      branch.rebase_to_master
      branch.push
      branch.open_pull_request(options)
    end

    def cleanup
      Cleanup.new(Branch.current.target).run
    end

    private

      attr_reader :local_config

      def board
        @_board ||= local_config.board
      end

      def update_master_branch
        master_branch = Branch.new("master")
        master_branch.pull
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
        label = Table.pick board.labels, caption: "Add label:"
        card = board.lists.backlog.cards.create name: name
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
