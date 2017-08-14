module TrelloFlow
  class LocalConfig
    PATH = ".trello_flow"

    def initialize(store = nil)
      @store = store || ConfigStore.new(PATH)
    end

    def board
      @_board ||= Trello::Board.find(board_id)
    end

    private

      attr_reader :store

      def board_id
        @_board_id ||= store[:board_id] || configure_board_id
      end

      def configure_board_id
        store.save :board_id, Table.pick(current_user.boards.active).id
      end

      def current_user
        Trello::Member.current
      end
  end
end
