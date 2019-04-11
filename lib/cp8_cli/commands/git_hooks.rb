require 'fileutils'

module Cp8Cli
  module Commands
    class GitHooks
      def run
        FileUtils.cp(source, destination)
      end

      private

        def source
          File.join(__dir__, "..", "templates", base_name)
        end

        def destination
          File.join(Dir.pwd, ".#{base_name}")
        end

        def base_name
          File.join("git", "hooks", "pre-push")
        end
    end
  end
end
