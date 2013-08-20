# The program is an extension of the Cinch IRCbot framework originally written
# by Dominik Honnef.
#
# The idea is to add a persistent storage container for use in cinch plugins,
# so that data can persist between runs without being hardcoded.
#
# Author::    Donovan C. Young  (mailto:dyoung522@gmail.com)
# Copyright:: Copyright (c) 2013 Donovan C. Young
# License::   MIT
#
# :include:LICENSE.txt

require 'cinch'
require 'cinch/extensions/storage/config'
require 'cinch/extensions/storage/version'
require 'cinch/extensions/storage/container'
