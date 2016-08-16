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

  url = ask "Input card URL:"
  card = Card.find(url)


  # create checklist if doesn't exist
  if card.checklists.size == 0
    checklist = Checklist.create(card: card, name: "To-Do")
    say "Added checklist to card"
  else
    checklist = card.checklists.first
  end


  #if checklist.items.size == 0
    #checklist.add_item
    #Trello::Checklist.create name: "To-Do", card_id: card.id
    #say "Added checklist to card"
  #end
  item = Table.new(checklist.items, title: "#{card.name} (#{checklist.name})").pick

  say "Create branch for '#{item.name}' and assign owner"
end
