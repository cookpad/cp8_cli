require "dolma/base"
require "dolma/board"
require "dolma/card"
require "dolma/check_item"
require "dolma/checklist"
require "dolma/list"
require "dolma/table"
require "dolma/version"
require "highline/import"
require "trello"

module Dolma
  #Trello.open_public_key_url
  #Trello.open_authorization_url key: "***REMOVED***"

  Trello.configure do |config|
    config.developer_public_key = "***REMOVED***"
    config.member_token = "***REMOVED***"
  end

  board = Table.new(Board.all).pick
  list = Table.new(board.lists).pick
  card = Table.new(list.cards).pick
  #checklist = Table.new(card.checklists).pick
  checklist = card.checklists.first #Table.new(card.checklists).pick
  item = Table.new(checklist.check_items).pick
  puts item

  say "Create branch for '#{item.name}' and move to developing"
end
