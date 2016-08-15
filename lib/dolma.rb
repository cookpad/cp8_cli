require "dolma/base"
require "dolma/board"
require "dolma/card"
require "dolma/checklist"
require "dolma/item"
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

  if card.checklists.size == 0
    Trello::Checklist.create name: "To-Do", card_id: card.id
    say "Added checklist to card"
  end

  # create checklist if doesn't exist
  checklist = card.checklists.first

  #if checklist.items.size == 0
    #Trello::Checklist.create name: "To-Do", card_id: card.id
    #say "Added checklist to card"
  #end
  item = Table.new(checklist.items).pick

  say "Create branch for '#{item.name}' and assign owner"
end
