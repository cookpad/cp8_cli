require "trello_flow/version"
require "trello_flow/local_config"
require "trello_flow/global_config"
require "trello_flow/github/issue"
require "trello_flow/current_user"

module TrelloFlow
  class Main
    def initialize(global_config = GlobalConfig.new, local_config = LocalConfig.new)
      Trello::Base.configure(key: global_config.trello_key, token: global_config.trello_token)
      Github::Base.configure(token: global_config.github_token)
      @local_config = local_config
    end

    def start(name)
      Cli.error "Your `trello_flow` version is out of date. Please run `gem update trello_flow`." unless Version.latest?
      story = create_or_pick_story(name)
      story.assign(current_user)
      story.start
      Branch.from_story(user: current_user, story: story).checkout
    rescue Trello::Error => error
      Cli.error(error.message)
    end

    def open
      Branch.current.open_story_in_browser
    end

    def finish(options = {})
      branch = Branch.current
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

      def create_or_pick_story(name)
        if name.to_s.start_with?("https://github.com")
          Github::Issue.find_by_url(name)
        elsif name.to_s.start_with?("http")
          Trello::Card.find_by_url(name)
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
        @_current_user ||= CurrentUser.new
      end
  end
end
