require "active_support/core_ext/string/inflections"
require "cp8_cli/ci"
require "cp8_cli/github/pull_request"
require "cp8_cli/branch_name"
require "cp8_cli/story_query"
require "cp8_cli/pull_request_title"
require "cp8_cli/pull_request_body"

module Cp8Cli
  class Branch
    def initialize(name)
      @name = name
    end

    def self.current
      new Command.read("git rev-parse --abbrev-ref HEAD")
    end

    def self.suggestion
      new("suggestion-#{SecureRandom.hex(8)}")
    end

    def self.from_story(user:, story:)
      new BranchName.new(
        user: user,
        target: current.target,
        title: story.title,
        short_link: story.short_link
      ).to_s
    end

    def checkout
      Command.run "git checkout #{name} >/dev/null 2>&1 || git checkout -b #{name}"
    end

    def push
      Command.run "git push origin #{name} -u"
    end

    def build_pull_request(prefixes:, **options)
      Github::PullRequest.new options.reverse_merge(
        from: name,
        title: PullRequestTitle.new(story, prefixes: prefixes).to_s,
        body: PullRequestBody.new(story).to_s,
        target: pull_request_target
      )
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

    def target
      name_parts[2] || name
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

      attr_reader :name

      def story
        @_story ||= StoryQuery.new(short_link).find if short_link
      end

      def short_link
        name_parts[3]
      end

      def name_parts
        @_name_parts ||= name.split(".")
      end

      def pull_request_target
        if plain_branch?
          "master"
        else
          target
        end
      end

      def plain_branch?
        short_link.blank?
      end

      def dirty?
        Command.read("git status --porcelain")
      end
  end
end
