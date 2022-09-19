# encoding: UTF-8

module Clirtest
class Test
class << self

  ##
  # On lance la suite de tests
  # 
  def run
    @items = @items.shuffle unless config.in_order?
    init
    begin
      @start_time = Time.now.to_f
      @items.each(&:run)
    rescue Exception => e
      puts "ERREUR SYSTÉMIQUE : #{e.message}".rouge
      puts e.backtrace.join("\n").rouge
    else
      # Sinon (si tout s'est bien passé), on affiche le
      # rapport.
      @end_time = Time.now.to_f
      report
    ensure
      ENV['MODE_CLI_TEST'] = 'false'
    end
  rescue Exception => e
    puts e.message.rouge
  end

  ##
  # Initialisation des tests
  # 
  def init
    @success  = []
    @failures = []
    ENV['MODE_CLI_TEST'] = 'true'
  end

  ##
  # Ajout d'un succès
  def add_success(test)
    @success << test
  end

  ##
  # Ajout d'un échec
  def add_failure(test)
    @failures << test
  end

  ##
  # Rapport final
  def report
    rapport_str = <<~TEXT

    #{'-'*60}
    Success: #{@success.count} – Failures: #{@failures.count} – Durée : #{duree_tests}
    #{'-'*60}
    TEXT
    # On écrit toutes les erreurs rencontrées
    if failures?
      @failures.each_with_index(&:print_error_report)
    end
    # On écrit le rapport général
    puts rapport_str.send(failures? ? :rouge : :vert)

  end

  def failures?
    @failures.count > 0
  end

  def duree_tests
    @duree_tests ||= begin
      ms = ((@end_time - @start_time) * 1000).round(2).to_s + ' ms'
    end
  end

  ##
  # Ajout du test +test+ à la liste des tests
  # (relève silencieuse des tests)
  # 
  def add(test)
    @items ||= []
    @items << test
  end

  ##
  # Configuration des tests
  def config
    @config ||= NewCliTest::Configuration.new
  end

end #/ << self class Test
end #/class Test
end #/module Clirtest
