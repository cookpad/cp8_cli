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

    def self.from_item(item)
      new("#{current.target}.#{item.to_param}.#{item.checklist_id}-#{item.id}")
    end

    def checkout
      Cli.run "git checkout -b #{name}"
    end

    def push
      Cli.run "git push origin #{name} -u"
    end

    def open_pull_request
      PullRequest.new(current_item, from: name, target: target).open
    end

    def complete_current_item
      current_item.complete
    end

    def open_trello(username)
      if current_item
        Cli.open_url current_item.card.url
      else
        Cli.open_url "https://trello.com/#{username}/cards"
      end
    end

    def target
      name.split('.').first
    end

    private

      attr_reader :name

      def ids
        name.split(".").last.split("-")
      end

      def checklist_id
        ids.first
      end

      def item_id
        ids.last if ids.size == 2
      end

      def current_item
        @_current_item ||= Api::Item.find(checklist_id, item_id) if item_id
      end
  end
end
