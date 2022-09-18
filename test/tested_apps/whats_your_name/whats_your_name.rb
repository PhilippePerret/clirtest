#!/usr/bin/env ruby
# encoding: UTF-8
require 'clirtest'

=begin
  L'exécutable de l'application exemple
=end
begin
  require_relative 'lib/required'
  if tests?
    Clirtest.run
  else
    WhatsYourName.ask_for_user_name.say_hello
  end
rescue Exception => e
  puts "Un problème est suvenu : #{e.message}".rouge
  puts e.backtrace.join("\n").rouge
end
