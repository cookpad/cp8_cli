module Dolma
  module Api
    class Card < Base
      has_many :checklists

      def self.find_by_url(url)
        return if url.blank?
        id = url.scan(/\/c\/(.+)\//).flatten.first
        find(id)
      end

      def find_or_create_checklist
        checklists.first || Checklist.create(idCard: id, name: "To-Do")
      end
    end
  end
end
