require "active_support/core_ext/string/inflections"

module Dolma
  class Branch

    attr_accessor :name

    def initialize(name)
      @name = name
    end

    def self.current
      new(`git rev-parse --abbrev-ref HEAD`.strip)
    end

    def self.from_item(item)
      new("#{current.target}.#{item.to_param}.#{item.id}")
    end

    def checkout
      Cli.run "git checkout -b #{name}"
    end

    def push
      Cli.run "git push origin #{name} -u"
    end

    def open_pull_request
      Cli.open pull_request_url
    end

    def target
      name.split('.').first
    end

    private

      def pull_request_url
        title = URI.escape "#{pull_request_prefix} #{pull_request_title}".strip
        repo.url + "/compare/#{target}...#{branch}?expand=1&title=#{title}"
      end

      def pull_request_title
        current_item.name.gsub('"',"'") + " [Delivers ##{item_id}]"
      end

      def pull_request_prefix
        prefixes = []
        # prefixes << "[WIP]" if @options[:wip]
        prefixes << "[#{target.titleize}]" if release_branch?
        prefixes.join(" ")
      end

      def release_branch?
        target != 'master'
      end

      def checklist_id

      end

      def item_id
        name[/\d+$/] || ''
      end

      def current_item
        Item.find(item_id)
      end
  end
end
