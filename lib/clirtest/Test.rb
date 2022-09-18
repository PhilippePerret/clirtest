=begin

  La classe de chaque test

=end

##
# expose outside
def test(name, &block)
  Clirtest::Test.new(name, &block)
end

module Clirtest
class << self
  attr_reader :tests
  def add_test(itest)
    @tests ||= []
    @tests << itest
  end
end #/<< self (Clirtest)

# --- CLASSE DES TESTS ---
# TODO Reprendre ici tout ce qui a été défini dans NewCliTest
# 
class Test
  
  attr_reader :name
  def initialize(name, &block)
    @name = name
    instance_eval(&block) if block_given
    Clirtest.add_test(self)
  end


  def run
    puts "Je dois apprendre à jouer le test ".jaune

  rescue CLiTestNoMoreValuesError => e
    # TODO traiter le cas d'un défaut 'inputs'
  end

  def place
    nil # TODO (l'endroit où le test est défini : <rel path>::<line>)
  end

end #/class Test
end #/module Clirtest
