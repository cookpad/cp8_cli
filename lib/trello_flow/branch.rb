require "active_support/core_ext/string/inflections"
require "trello_flow/pull_request"

module TrelloFlow
  class Branch
    def initialize(name)
      @name = name
    end

    def self.current
      new Cli.read("git rev-parse --abbrev-ref HEAD")
    end

    def self.from_card(user:, card:)
      new("#{user.initials.downcase}.#{card.to_param}.#{current.target}.#{card.short_link}")
    end

    def checkout
      Cli.run "git checkout #{name} >/dev/null 2>&1 || git checkout -b #{name}"
    end

    def push
      Cli.run "git push origin #{name} -u"
    end

    def pull
      Cli.run "git pull origin #{name}"
    end

    def rebase(branch = "master")
      Cli.run "git rebase #{branch}"
    end

    def open_pull_request(options = {})
      PullRequest.new(current_card, options.merge(from: name, target: target)).open
    end

    def open_trello(user:, config:)
      if current_card
        Cli.open_url current_card.url
      else
        Cli.open_url config.board.url
      end
    end

    def target
      if legacy_naming?
        name_parts.first
      else
        name_parts[-2] || name
      end
    end

    private

      attr_reader :name

      def current_card
        @_current_card ||= Api::Card.find(card_short_link) if card_short_link
      end

      def card_short_link
        name[/\.(\w+)$/, 1]
      end

      def legacy_naming?
        name_parts.size == 3
      end

      def name_parts
        @_name_parts ||= name.split(".")
      end
  end
end
