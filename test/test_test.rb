=begin

  Test d'une instance Clirtest::Test
=end
require 'test_helper'

class InstanceTestTest  < Minitest::Test

def new_instance(data = nil, &block)
  data ||= {}
  data[:name] ||= "Un test quelconque à #{Time.now}"
  itest = Clirtest::Test.new(data[:name])
  if block_given?
    itest.instance_eval(&block)
  end
  return itest
end


def test_respond_to_valid?
  itest = new_instance
  assert_respond_to itest, :valid?  
end

def test_valid_return_right_value
  itest = new_instance do
    when_run 'ls'
    resultat_is 4
  end
  assert itest.valid?

  itest = new_instance do 
    when_run 'ls'
  end
  refute itest.valid?
  assert_equal ERRORS['en'][2001], itest.fatal_error

  itest = new_instance do
    resultat_is 'ls'
  end
  refute itest.valid?
  assert_equal ERRORS['en'][2000], itest.fatal_error
end


end #/InstanceTestTest
