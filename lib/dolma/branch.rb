require "active_support/core_ext/string/inflections"
require "dolma/pull_request"

module Dolma
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

    def open_trello_card
      Cli.open_url current_item.card.url
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
        ids.last
      end

      def current_item
        @_current_item ||= Api::Item.find(checklist_id, item_id)
      end
  end
end
