module Cp8Cli
  module Trello
    class List < Base
      BACKLOG_INDEX = 0
      STARTED_INDEX = 1
      FINISHED_INDEX = 2
      ACCEPTED_INDEX = 3

      has_many :cards

      def self.fields
        [:name]
      end

      def self.backlog
        all[BACKLOG_INDEX]
      end

      def self.started
        all[STARTED_INDEX]
      end

      def self.finished
        all[FINISHED_INDEX]
      end

      def self.accepted
        all[ACCEPTED_INDEX]
      end
    end
  end
end
