require 'pp'
require_relative 'lib/cinch/extensions/storage'

items = Cinch::Extensions::Storage.register(:items) # Create a dataset

p items.exists?(:test)

items[:test] = "value"

puts "items[:test] = " + items[:test]
