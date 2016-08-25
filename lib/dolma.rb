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

  # Config, should be done once and stored like pt-flow
  ask "Press enter to setup Trello for this project (will open public key url)"
  Trello.open_public_key_url

  public_key = ask("Input Developer API key")
  Trello.open_authorization_url key: public_key

  Trello.configure do |config|
    config.developer_public_key = public_key
    config.member_token = ask("Input member token")
  end

  username = "balvig"

  # Actual flow
  `open https://trello.com/#{username}/cards` if ARGV.empty?
  url = ARGV.first || ask("Input card URL:")
  card = Card.find_by_url(url)

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
  item.assign(card, checklist, username)

  say "Create branch for '#{item.name}'"
end
