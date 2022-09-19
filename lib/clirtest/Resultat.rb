module Clirtest
class Test
class Resultat

  attr_reader :test
  attr_reader :expected, :actual

  # @param {Clirtest} test
  # @param {Foo} value Valeur définie en argument
  def initialize test, expected = nil, &block
    @test  = test
    @expected = expected
    instance_eval(&block) if block_given?
  end

  ##
  # Méthode qui reçoit la valeur obtenue et la compare à la
  # valeur attendue.
  # @return TRUE si elles correspondent.
  # 
  def is(val)
    @actual = real_actual(val)
    return actual == expected
  end

  def error
    "\tAttendu: #{expected.inspect}\n\tObtenu : #{actual.inspect}"
  end

  ## 
  # La plupart du temps, le résultat émane de la console, il faut
  # donc la transformer en la même valeur que l'expected
  # 
  def real_actual(val)
    return val if not val.is_a?(String)
    val = val.strip
    case expected
    when Integer  then val.to_i
    when Float    then val.to_f
    when Symbol   then val.to_sym
    else val
    end
  end

  def value(val)
    @expected = val
  end
  alias :value= :value

end #/class Resultat
end #/class Test
end #/module Clirtest
