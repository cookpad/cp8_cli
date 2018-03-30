require "active_support/core_ext/string/inflections"
require "cp8_cli/ci"
require "cp8_cli/github/pull_request"
require "cp8_cli/branch_name"
require "cp8_cli/current_user"
require "cp8_cli/pull_request_title"
require "cp8_cli/pull_request_body"

module Cp8Cli
  class Branch

    attr_reader :name

    def initialize(name)
      @name = name
    end

    def self.current
      new Command.read("git rev-parse --abbrev-ref HEAD")
    end

    def self.suggestion
      new("suggestion-#{SecureRandom.hex(8)}")
    end

    def self.from_story(story)
      default_branch_name = BranchName.new(
        user: CurrentUser.new,
        story: story
      ).to_s

      new Command.ask("Branch name [#{default_branch_name}]:") { |q| q.default = default_branch_name }
    end

    def checkout
      Command.run "git checkout #{name} >/dev/null 2>&1 || git checkout -b #{name}"
    end

    def push
      Command.run "git push origin #{name} -u"
    end

    def open_pr
      pull_request.open
    end

    def open_ci
      Ci.new(branch_name: name, repo: repo).open
    end

    def open_story_in_browser
      open_pr
      #if story
        #Command.open_url story.url
      #else
        #Command.error "Not currently on story branch"
      #end
    end

    def reset
      if dirty?
        Command.error "Dirty working directory, not resetting."
      else
        Command.run("git reset --hard origin/#{name}")
      end
    end

    def to_s
      name
    end

    private

      def repo
        Repo.current
      end

      def dirty?
        Command.read("git status --porcelain")
      end

      def pull_request
        existing_pull_request || new_pull_request
      end

      def existing_pull_request
        Github::PullRequest.find_by(branch: name, repo: repo)
      end

      def new_pull_request
        Github::PullRequest.new(from: name)
      end
  end
end
