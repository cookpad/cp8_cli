module Cp8Cli
  class Ci
    def initialize(branch_name:, repo:)
      @branch_name = branch_name
      @repo = repo
    end

    def open
      Command.open_url url
    end

    private

      attr_reader :branch_name, :repo

      def url
        "https://circleci.com/gh/#{repo.user}/#{repo.name}/tree/#{URI.escape branch_name}"
      end
  end
end
