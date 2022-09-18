require "clir"
require "clirtest/version"
require 'clirtest/errors_and_messages'

module Clirtest
  class ClirtestError < StandardError; end

  class << self

    ##
    # Run all tests
    #
    def run
      tests_folder_exist? || raise(ClirtestError.new 1000)
    rescue ClirtestError => e
      puts ERRORS[lang][e.message.to_i].rouge
    rescue Exception => e
      raise e
    end

    def lang
      'fr' # TODO
    end

    ##
    # @return true if tests folder exists
    def tests_folder_exist?
      File.exist?(tests_folder)
    end
  
    ##
    # @return the path to tests folder
    def tests_folder
      @tests_folder ||= File.join(app_folder,'tests')
    end

    ##
    # @return test files list
    def test_files
      @test_files ||= Dir["#{tests_folder}/**/*_test.rb"]
    end

    ##
    # @return the app folder path
    def app_folder
      @app_folder ||= begin
        if defined?(APP_FOLDER)
          APP_FOLDER
        else
          File.expand_path('.')
        end
      end
    end

    ##
    # To define app_folder (only for tests)
    def app_folder=(path)
      @app_folder = path
      @tests_folder = nil
      @test_files   = nil
    end

    private

  end #/<< self
end #/module Clirtest
