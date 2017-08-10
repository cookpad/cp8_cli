require "active_support/core_ext/string/inflections"
require "trello_flow/pull_request"
require "trello_flow/branch_name"

module TrelloFlow
  class Branch
    def initialize(name)
      @name = name
    end

    def self.current
      new Cli.read("git rev-parse --abbrev-ref HEAD")
    end

    def self.from_card(user:, card:)
      new BranchName.new(user: user, target: current.target, card: card).to_s
    end

    def checkout
      Cli.run "git checkout #{name} >/dev/null 2>&1 || git checkout -b #{name}"
    end

    def push
      Cli.run "git push origin #{name} -u"
    end

    def open_pull_request(options = {})
      pr = PullRequest.new options.merge(card: current_card, from: name, target: target)
      pr.open
    end

    def open_trello(config)
      if current_card
        Cli.open_url current_card.url
      else
        Cli.open_url config.board.url
      end
    end

    def target
      name_parts[2] || name
    end

    private

      attr_reader :name

      def current_card
        @_current_card ||= Api::Card.find(card_short_link) if card_short_link
      end

      def card_short_link
        name_parts[3]
      end

      def name_parts
        @_name_parts ||= name.split(".")
      end
  end
end
