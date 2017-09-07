require "active_support/core_ext/string/inflections"
require "cp8_cli/ci"
require "cp8_cli/pull_request"
require "cp8_cli/branch_name"
require "cp8_cli/story_query"

module Cp8Cli
  class Branch
    def initialize(name)
      @name = name
    end

    def self.current
      new Command.read("git rev-parse --abbrev-ref HEAD")
    end

    def self.from_story(user:, story:)
      new BranchName.new(user: user, target: current.target, story: story).to_s
    end

    def checkout
      Command.run "git checkout #{name} >/dev/null 2>&1 || git checkout -b #{name}"
    end

    def push
      Command.run "git push origin #{name} -u"
    end

    def open_pull_request(options = {})
      pr = PullRequest.new options.merge(story: current_story, from: name, target: target)
      pr.open
    end

    def open_ci
      Ci.new(branch_name: name, repo: Repo.current).open
    end

    def open_story_in_browser
      if current_story
        Command.open_url current_story.url
      else
        Command.error "Not currently on story branch"
      end
    end

    def target
      name_parts[2] || name
    end

    private

      attr_reader :name

      def current_story
        @_current_story ||= StoryQuery.new(short_link).find if short_link
      end

      def short_link
        name_parts[3]
      end

      def name_parts
        @_name_parts ||= name.split(".")
      end
  end
end
