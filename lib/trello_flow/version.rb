module TrelloFlow
  VERSION = "3.5.0"
  class Version
    def self.latest?
      new.latest?
    end

    def latest?
      latest_version <= current_version
    end

    private

      def latest_version
        @_latest_version ||= Gem.latest_version_for("trello_flow")
      end

      def current_version
        @_current_version ||= Gem::Version.new(VERSION)
      end
  end
end
