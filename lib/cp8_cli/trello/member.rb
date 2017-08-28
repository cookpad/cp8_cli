module Cp8Cli
  module Trello
    class Member < Base
      has_many :boards

      def self.current
        with("tokens/#{token}/member").find_one
      end
    end
  end
end
