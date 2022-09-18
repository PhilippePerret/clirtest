# encoding: UTF-8

APP_FOLDER = File.dirname(__dir__)

Dir["#{__dir__}/required/**/*.rb"].each{|m|require(m)}
