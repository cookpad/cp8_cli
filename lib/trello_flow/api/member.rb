module TrelloFlow
  module Api
    class Member < Base
      def self.current
        with("tokens/#{token}/member").find_one
      end
    end
  end
end
