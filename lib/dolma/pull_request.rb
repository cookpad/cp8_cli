require "dolma/repo"

module Dolma
  class PullRequest
    def initialize(item, from:, target:)
      @item = item
      @from = from
      @target = target
    end

    def open
      Cli.open_url url
    end

    private

      attr_reader :item, :from, :target

      def url
        repo.url + "/compare/#{target}...#{from}?expand=1&title=#{escape title_with_prefixes}&body=#{escape body}"
      end

      def title
        item.name_without_mentions.gsub('"',"'")
      end

      def body
        "Trello: #{item.card.url}"
      end

      def prefixes
        prefixes = []
        # prefixes << "[WIP]" if @options[:wip]
        prefixes << "[#{target.titleize}]" if release_branch?
        prefixes.join(" ")
      end

      def release_branch?
        target != "master"
      end

      def title_with_prefixes
        "#{prefixes} #{title}".strip
      end

      def escape(text)
        URI.escape text.strip
      end

      def repo
        @_repo ||= Repo.new
      end
  end
end
