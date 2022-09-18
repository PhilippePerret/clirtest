require "clir"
require "clirtest/version"
require 'clirtest/errors_and_messages'
require 'clirtest/Test'

module Clirtest
  class ClirtestError < StandardError; end
  class CLiTestNoMoreValuesError < StandardError; end

  class << self

    ##
    # Run all tests
    #
    def run
      tests_folder_exist? || raise(ClirtestError.new 1000)
      load_tests
      if no_test?
        raise(ClirtestError.new 100) 
      else
        commence
        run_tests
        termine
      end
    rescue ClirtestError => e
      puts ERRORS[lang][e.message.to_i].rouge
    rescue Exception => e
      raise e
    end

    ##
    # Called before to run test
    def commence
      puts "Je dois apprendre à commencer les tests".jaune
    end

    ##
    # Called when all test have been run
    def termine
      puts "Je dois apprendre à terminer les tests".jaune
    end

    def lang
      'fr' # TODO
    end

    ##
    # @return true if there's zero test to run
    def no_test?
      return tests.nil? || tests.empty?
    end

    ##
    # Run every test
    def run_tests
      tests.shuffle.each do |test|
        test.run
      end
    end

    ##
    # Load every test file
    #
    # Later: we'll be able to choose the tests to run
    # 
    def load_tests
      test_files.each { |ft| require ft }
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
