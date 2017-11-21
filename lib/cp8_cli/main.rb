require "cp8_cli/version"
require "cp8_cli/local_config"
require "cp8_cli/global_config"
require "cp8_cli/github/issue"
require "cp8_cli/adhoc_story"
require "cp8_cli/current_user"

module Cp8Cli
  class Main
    def initialize(global_config = GlobalConfig.new, local_config = LocalConfig.new)
      Trello::Base.configure(key: global_config.trello_key, token: global_config.trello_token)
      Github::Base.configure(token: global_config.github_token)
      @local_config = local_config
    end

    def start(name)
      Command.error "Your `cp8_cli` version is out of date. Please run `gem update cp8_cli`." unless Version.latest?
      story = create_or_pick_story(name)
      story.assign(current_user)
      story.start
      Branch.from_story(user: current_user, story: story).checkout
    rescue Trello::Error => error
      Command.error(error.message)
    end

    def open
      Branch.current.open_story_in_browser
    end

    def submit(options = {})
      branch = Branch.current
      branch.push
      branch.open_pull_request(options)
    end

    def ci
      Branch.current.open_ci
    end

    def suggest
      original_branch = Branch.current
      suggestion_branch = Branch.new("suggestion-#{SecureRandom.hex(8)}")
      suggestion_branch.checkout
      suggestion_branch.push
      suggestion_branch.open_pull_request(target: original_branch, expand: false)
      original_branch.checkout
      original_branch.reset
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
          AdhocStory.new(name)
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
