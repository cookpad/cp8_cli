$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "trello_flow"

require "minitest/autorun"
require "pry"

# Require support files
Dir[File.expand_path("../support/**/*.rb", __FILE__)].each { |f| require f }
