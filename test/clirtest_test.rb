require "test_helper"

class ClirtestTest < Minitest::Test

  def app_with_tests
    File.join(CLIRTEST_FOLDER,'test','tested_apps','app_with_tests')
  end
  def app_without_tests
    File.join(CLIRTEST_FOLDER,'test','tested_apps','app_without_tests')
  end

  def test_that_it_has_a_version_number
    refute_nil ::Clirtest::VERSION
  end

  def test_clirtest_respond_to_run
    assert_respond_to Clirtest, :run
  end

  def test_respond_to_app_folder
    assert_respond_to Clirtest, :app_folder
  end

  def test_app_folder_returns_the_right_value
    Clirtest.app_folder = app_with_tests
    assert_equal Clirtest.app_folder, app_with_tests
  end

  def test_respond_to_tests_folder
    assert_respond_to Clirtest, :tests_folder
  end
  def test_tests_folder_return_right_path
    Clirtest.app_folder = app_with_tests
    assert_equal File.join(app_with_tests,'tests'), Clirtest.tests_folder
  end

  def test_warning_if_tests_folder_does_not_exist
    Clirtest.app_folder = File.join(CLIRTEST_FOLDER,'test','tested_apps','app_without_tests')
    out, err = capture_io { Clirtest.run }
    assert_match ERRORS['en'][1000], out
    assert_empty err
  end

  def test_test_folder_exists_return_right_value
    Clirtest.app_folder = app_without_tests
    refute Clirtest.tests_folder_exist?
    Clirtest.app_folder = app_with_tests
    assert Clirtest.tests_folder_exist?
  end

  def test_respond_to_test_files
    assert_respond_to Clirtest, :test_files
  end

  def test_tests_files_return_all_files
    Clirtest.app_folder = app_with_tests
    files = Clirtest.test_files
    assert files.is_a?(Array)
    refute files.empty?
    assert_operator files.count, :>=, 4
    assert_includes files, File.join(app_with_tests,'tests','premier_test.rb')
    assert_includes files, File.join(app_with_tests,'tests','sous_dossier','sous_sous_dossier','dernier_test.rb')
    fnontest = File.join(app_with_tests, 'tests', 'not_a_test_at_all.rb')
    assert File.exist?(fnontest)
    refute_includes files, fnontest
  end

  def test_respond_to_load_tests
    assert_respond_to Clirtest, :load_tests
  end

  def test_load_tests_load_the_tests
    Dir.chdir(app_with_tests) do
      Clirtest.run # ça fait comme si on faisait les tests
    end
    #
    # Les tests qu'on devrait trouver pour cette application
    # (note : cette liste n'est pas exhaustive)
    # 
    tests_to_find = {
      "Un tout premier test"  => './tests/premier_test.rb::12',
      "Un autre tests simple" => './tests/autre_test.rb::12'
    }
    Clirtest::Test.items.each do |test|
      if tests_to_find.key?(test.name)
        assert_equal test.place.to_str, tests_to_find[test.name]
        tests_to_find.delete(test.name)
      end
    end
    assert_empty tests_to_find
  end
  
  def test_respond_to_run_tests
    assert_respond_to Clirtest::Test, :run_tests
  end
  def test_respond_to_init_run
    assert_respond_to Clirtest::Test, :init_run
  end
  def test_init_run_do_its_job
    Clirtest::Test.instance_variable_set('@success', nil)
    Clirtest::Test.instance_variable_set('@failures', nil)
    assert_nil Clirtest::Test.success
    assert_nil Clirtest::Test.failures
    Clirtest::Test.init_run
    assert_equal [], Clirtest::Test.success
    assert_equal [], Clirtest::Test.failures
  end

  def test_run_tests_run_the_tests
    assert false
  end

end
