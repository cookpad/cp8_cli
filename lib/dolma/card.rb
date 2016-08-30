module Dolma
  class Card < Base
    def self.find_by_url(url)
      return if url.blank?
      id = url.scan(/\/c\/(.+)\//).flatten.first
      new Trello::Card.find(id)
    end

    def checklists
      super.map { |obj| Checklist.new(obj) }
    end
  end
end
