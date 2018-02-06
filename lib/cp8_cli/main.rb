require "cp8_cli/version"
require "cp8_cli/global_config"
require "cp8_cli/commands/ci"
require "cp8_cli/commands/open"
require "cp8_cli/commands/start"
require "cp8_cli/commands/submit"
require "cp8_cli/commands/suggest"

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
      Commands::Open.new.run
    end

    def submit(options = {})
      Commands::Submit.new(options).run
    end

    def ci
      Commands::Ci.new.run
    end

    def suggest
      Commands::Suggest.new.run
    end
  end
end
