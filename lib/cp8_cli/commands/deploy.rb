module Cp8Cli
  module Commands
    class Deploy
      BOT_NAME = "ruboty-1767"

      def initialize(environment)
        @environment = environment
      end

      def run
        copy_to_clipboard(slack_command)
        open_slack
      end

      private

        attr_reader :environment

        def copy_to_clipboard(text)
          Command.run "echo \"#{text}\" | pbcopy"
        end

        def slack_command
          "@#{BOT_NAME} deploy #{Repo.current.name}/#{Branch.current} to #{environment}"
        end

        def open_slack
          Command.run "open /Applications/Slack.app"
        end
    end
  end
end
