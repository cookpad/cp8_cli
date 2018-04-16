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

    def checkout
      Command.run "git checkout #{name} >/dev/null 2>&1 || git checkout -b #{name}", title: "Checking out new branch"
    end

    def push
      Command.run "git push origin #{name} -u", title: "Pushing to origin"
    end

    def open_pr
      pull_request.open
    end

    def open_ci
      Ci.new(branch_name: name, repo: repo).open
    end

    def reset
      if dirty?
        Command.error "Dirty working directory, not resetting."
      else
        Command.run "git reset --hard origin/#{name}", title: "Resetting branch"
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
