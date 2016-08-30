require "dolma/base"
require "dolma/board"
require "dolma/card"
require "dolma/checklist"
require "dolma/config"
require "dolma/item"
require "dolma/list"
require "dolma/table"
require "dolma/version"
require "highline/import"
require "trello"

module Dolma
  config = Config.new
  config.configure_trello

  # Actual flow
  `open https://trello.com/#{config.username}/cards` if ARGV.empty?
  url = ARGV.first || ask("Input card URL:")
  card = Card.find_by_url(url)

  # create checklist if doesn't exist
  if card.checklists.size == 0
    checklist = Checklist.create(card: card, name: "To-Do")
    say "No to-do list found. Added blank"
  else
    checklist = card.checklists.first
  end

  # add item if none exists
  if checklist.items.size != 0
    say "No to-dos found"
    title = ask("Input to-do (or leave blank to use card title)") || card.name
    item = checklist.add_item(title)
  else
    item = Table.new(checklist.items, title: "#{card.name} (#{checklist.name})").pick
  end

  item.assign(card, checklist, config.username)

  say "Create branch for '#{item.name}'"
end
