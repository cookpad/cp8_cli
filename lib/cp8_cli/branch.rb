require "active_support/core_ext/string/inflections"
require "cp8_cli/ci"
require "cp8_cli/github/pull_request"
require "cp8_cli/branch_name"
require "cp8_cli/current_user"
require "cp8_cli/story_query"
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
      new BranchName.new(
        user: CurrentUser.new,
        short_link: story.short_link
      ).to_s
    end

    def story
      @_story ||= StoryQuery.new(short_link).find if short_link
    end

    def checkout
      Command.run "git checkout #{name} >/dev/null 2>&1 || git checkout -b #{name}"
    end

    def push
      Command.run "git push origin #{name} -u"
    end

    def open_ci
      Ci.new(branch_name: name, repo: Repo.current).open
    end

    def open_story_in_browser
      if story
        Command.open_url story.url
      else
        Command.error "Not currently on story branch"
      end
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

      def short_link
        return unless linked_branch?

        name_parts[1..2].join("/")
      end

      def linked_branch?
        name_parts.size == 3
      end

      def name_parts
        @_name_parts ||= name.split("/")
      end

      def dirty?
        Command.read("git status --porcelain")
      end
  end
end
