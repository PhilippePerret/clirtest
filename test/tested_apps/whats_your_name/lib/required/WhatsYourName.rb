# encoding: UTF-8
class WhatsYourName
class << self
  attr_reader :prenom

  def ask_for_user_name
    @prenom = Q.ask("Quel est votre nom ?".jaune)  
    return self # chainage
  end

  def say_hello
    puts "Bien le bonjour, #{prenom} !"  
  end

end
end
