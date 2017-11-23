require "cp8_cli/version"
require "cp8_cli/global_config"
require "cp8_cli/commands/start"

module Cp8Cli
  class Main
    def initialize(global_config = GlobalConfig.new)
      Trello::Base.configure(key: global_config.trello_key, token: global_config.trello_token)
      Github::Base.configure(token: global_config.github_token)
    end

    def start(name)
      Commands::Start.new(name).run
    end

    def open
      Branch.current.open_story_in_browser
    end

    def submit(options = {})
      branch = Branch.current
      branch.push

      pr = Github::PullRequest.new(
        from: branch,
        to: branch.target,
        title: PullRequestTitle.new(branch.story&.pr_title, prefixes: options.keys),
        body: PullRequestBody.new(branch.story)
      )

      pr.open
    end

    def ci
      Branch.current.open_ci
    end

    def suggest
      original_branch = Branch.current
      suggestion_branch = Branch.suggestion
      suggestion_branch.checkout
      suggestion_branch.push

      pr = Github::PullRequest.new(
        from: suggestion_branch,
        to: original_branch,
      )

      pr.open(expand: false)

      original_branch.checkout
      original_branch.reset
    end

    def cleanup
      Cleanup.new(Branch.current.target).run
    end
  end
end
