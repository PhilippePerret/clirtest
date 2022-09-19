# encoding: UTF-8

module Clirtest
class Should
class << self

  def equal(actual, expected, hsujet = nil, hresultat = nil)
    new(actual, expected, 'égal à', hsujet, hresultat).evaluate
  end

  def not_equal(actual, expected, hsujet = nil, hresultat = nil)
    new(actual, expected, 'pas égal à', hsujet, hresultat, true).evaluate
  end

end #/<< self Should

# --- INSTANCE ---

def initialize(actual, expected, hoperator, hsujet, hresultat, negation = false)
  @actual     = actual
  @expected   = expected
  @hsujet     = hsujet || actual
  @hresultat  = hresultat || expected
  @hoperator  = hoperator
  @negation   = negation
end

def evaluate
  ok = @actual == @expected
  raise message_failure if ok == @negation
end

def message_failure
  "#{@hsujet} devrait être #{@hoperator} #{@hresultat} (le résultat est #{@actual.inspect})"
end

end #/class Should
end #/module Clirtest
