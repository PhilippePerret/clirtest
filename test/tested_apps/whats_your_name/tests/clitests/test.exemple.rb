# encoding: UTF-8
=begin

  Exemple de test 

=end
module NewCliTest

test "La commande doit renvoyer le bon message" do
  when_run    'ruby /Users/philippeperret/Programmes/NewCliTest/exemple/whats_your_name/whats_your_name.rb'
  with_input  'Phil'
  resultat_is 'Bien le bonjour, Phil !'
end

end #/module NewCliTest
