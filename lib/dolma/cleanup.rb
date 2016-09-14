module Dolma
  class Cleanup
    def initialize(target)
      @target = target
    end

    def run
      Cli.title "Cleaning merged story branches for [#{target}]"
      update_remotes
      remove_fully_merged_local_branches
      remove_fully_merged_remote_branches
      Cli.success "Deleted branches merged with [#{target}]"
    end

    private

      attr_reader :target

      def update_remotes
        Cli.run "git fetch"
        Cli.run "git remote prune origin"
      end

      def remove_fully_merged_local_branches
        Cli.run "git branch --merged origin/#{target} | grep '#{filter}' | xargs git branch -D"
      end

      def remove_fully_merged_remote_branches
        Cli.run "git branch -r --merged origin/#{target} | sed 's/ *origin\\///' | grep '#{filter}'" | xargs -I% git push origin :%"
      end

      def filter
        "^ *#{target}.+.+$"
      end
  end
end
