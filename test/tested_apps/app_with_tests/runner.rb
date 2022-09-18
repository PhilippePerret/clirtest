#!/usr/bin/env ruby
require 'clirtest'

puts "J'entre dans le runner.".jaune

CLI.init
if test?
  puts "Je dois lancer les tests.".jaune
  Clirtest.run
else
  #
  # Plus tard, on mettra des commandes pour répondre aux tests
  #
end
