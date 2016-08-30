module Dolma
  class Card < Base
    has_many :checklists

    def self.find_by_url(url)
      return if url.blank?
      id = url.scan(/\/c\/(.+)\//).flatten.first
      new Trello::Card.find(id)
    end
  end
end
