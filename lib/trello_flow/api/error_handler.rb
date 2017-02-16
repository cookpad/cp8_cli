require "trello_flow/api/error"

module TrelloFlow
  module Api
    class ErrorHandler < Faraday::Middleware
      def call(env)
        @app.call(env).on_complete do
          status_code = env.status
          response_body = env[:body]

          if status_code == 404
            raise NotFound, error_message(response_body)
          end
        end
      end

      private

      def error_message(message)
        if member_endpoint?(message)
          "Verify your API key and token are correct at '~/.trello_flow'"
        else
          message
        end
      end

      def member_endpoint?(message)
        !!(message =~ /\/member/)
      end
    end
  end
end
