require "trello_flow/repo"

module TrelloFlow
  class PullRequest
    def initialize(card, from:, target:)
      @card = card
      @from = from
      @target = target
    end

    def open
      Cli.open_url url
    end

    private

      attr_reader :card, :from, :target

      def url
        repo.url + "/compare/#{target}...#{from}?expand=1&title=#{escape title_with_prefixes}&body=#{escape body}"
      end

      def title
        card.name.gsub('"',"'") + " [Delivers ##{card.short_link}]"
      end

      def body
        "Trello: #{card.short_url}"
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
