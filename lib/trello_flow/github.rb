require "octokit"

module TrelloFlow
  module Github
    def self.client
      @_client ||= octokit
    end

    def self.octokit
      raise "OCTOKIT_ACCESS_TOKEN env variable not set" unless ENV["OCTOKIT_ACCESS_TOKEN"]
      @_octokit ||= Octokit::Client.new
    end
  end
end
