module TrelloFlow
  class StoryQuery
    def initialize(short_link)
      @short_link = short_link
    end

    def find
      if github_issue?
        Github::Issue.find_by_short_link(short_link)
      else
        Trello::Card.find(short_link)
      end
    end

    private

      attr_reader :short_link

      def github_issue?
        short_link.include?("#")
      end
  end
end
