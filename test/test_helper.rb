$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'dolma'

require 'minitest/autorun'

# Require support files
Dir[File.expand_path('../support/**/*.rb', __FILE__)].each { |f| require f }
