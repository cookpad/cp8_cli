require "trello_flow/trello/error"

module TrelloFlow
  module Trello
    class ErrorHandler < Faraday::Middleware
      def call(env)
        @app.call(env).on_complete do
          if !env.success?
            raise Error, env[:body]
          end
        end
      end
    end
  end
end
