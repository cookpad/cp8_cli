module Dolma
  class Repo
    def user
      path.split('/').first
    end

    def name
      path.split('/').last
    end

    def url
      "https://github.com/#{user}/#{name}"
    end

    private

      def path
        @_path ||= Cli.run("git config --get remote.origin.url").match(/github.com[:\/](\S+\/\S+)\.git/)[1]
      end
  end
end
