=begin

  La classe de chaque test

=end

##
# expose outside
def clirtest(name, &block)
  Clirtest::Test.new(name, &block)
end

# --- INSTANCE DES TESTS ---

module Clirtest
class Test

  class RegularTestError  < StandardError; end
  class FatalTestError    < StandardError; end

  
  attr_reader :name
  attr_reader :place
  attr_reader :fatal_error


  def initialize(name, &block)
    @name   = name
    @place  = extract_from(caller[2]) #=> {PlaceInFile}
    instance_eval(&block) if block_given?
    self.class.add(self)
  end

  # --- Public Methods ---

  ##
  # Définir la commande à jouer
  def when_run commande
    @commande = commande
  end

  ##
  # Définir les entrées de l'utilisateur
  # 
  def with_inputs inputs
    inputs = [inputs] unless inputs.is_a?(Array)
    @inputs = inputs
  end
  alias :with_input :with_inputs

  ##
  # Pour définir le résultat attendu
  def resultat_is value = nil, &block
    @resultat = Resultat.new(self, value, &block)
  end

  ##
  # Pour définir un test-préliminaire
  # Ce test doit impérativement retourner true pour que
  # le test se fasse
  def pre_check &block
    @proc_pre_check = block if block_given?
  end

  # --- Execution Methods ---

  ##
  # Exécution du test
  # 
  def run
    valid? || begin
      on_failure(fatal_error)
      return
    end
    exec_proc_pre_check || return
    begin
      exec_operation
    rescue CLiTestNoMoreValuesError => e
      on_failure(e.message)
    rescue RegularTestError => e
      on_failure(e.message)
    rescue Exception => e
      # Erreur systémique
      raise e
    else
      on_success
    end
  end


  ##
  # Exécution du test proprement dit
  def exec_operation
    ENV['CLI_TEST_INPUTS'] = @inputs.to_json
    res_command = `#{@commande} 2>&1`
    exitstatus  = $?.exitstatus
    no_problem_with_command  = $?.success?
    
    if no_problem_with_command
      
      # 
      # La commande a pu être jouée, on prend le
      # résultat attendu pour le comparé au résultat
      # de la commande.
      # 
      if @resultat.is(res_command)
        on_success
      else
        raise RegularTestError.new(@resultat.error)
      end

    else

      # 
      # Un problème avec la commande
      #
      err = 
        if ERROR_CODES.key?(exitstatus)
          ERROR_CODES[exitstatus] % {test: self.inspect}
        else
          "la commande a échoué avec le code d'erreur #{exitstatus}."
        end
      err = "Impossible de tester, #{err}\n### Erreur retournée : '#{res_command.rouge}'"
      raise RegularTestError.new(err)
      
    end
  end

  # --- Report Methods ---

  ##
  # Écriture de l'erreur dans le rapport final
  # (méthode appelée seulement si le test a échoué)
  def print_error_report(indexError)
    puts "\n\n"
    titre = "Error ##{indexError + 1}"
    puts "#{titre}\n#{'-'*titre.length}".rouge + (' '*4) + "#{place.to_str}".gris
    puts @description.rouge if defined?(@description)
    puts (fatal_error || @error).rouge
  end

  # --- State Methods ---

  def valid?
    defined?(@commande) || raise(FatalTestError.new 2000)
    defined?(@resultat) || raise(FatalTestError.new 2001)
  rescue FatalTestError => e
    @fatal_error = ERRORS[Clirtest.lang][e.message.to_i]
    return false
  else
    return true
  end


  private



    ##
    # Méthode principale appelée en cas de succès
    # 
    def on_success(succ_msg = nil)
      self.class.add_success(self)
    end

    ##
    # Méthode principale appelée en cas d'erreur
    # Cela fait échouer le test et provoque l'enregistrement
    # d'une failure dans les tests
    def on_failure(err_msg)
      @error = "### #{err_msg}"
      self.class.add_failure(self)  
    end

    ##
    # Extraction du fichier et du numéro de ligne du test, pour
    # le localiser.
    # 
    def extract_from(calle)
      @from = PlaceInFile.new(*calle.split(':'))
    end

    ##
    # Exécution de la procédure de pré-check
    def exec_proc_pre_check
      return true unless defined?(@proc_pre_check)
      begin
        @proc_pre_check.call || raise("Le test préliminaire a échoué.")
      rescue Exception => e
        on_failure("erreur dans la procédure de pré-check : #{e.message}")
        return false
      else
        return true
      end
    end


end #/class Test

# :other peut être défini parce que les tests sont dans un module
PlaceInFile = Struct.new(:relpath, :line, :method, :other) do
  def path
    @path ||= File.expand_path(relpath)
  end
  def filename
    @filename ||= File.basename(relpath)
  end
  def relative_path
    @relative_path ||= path.sub(/^#{Regexp.escape(Clirtest.app_folder)}/,'.')
  end
  def to_str
    @to_str ||= "#{relative_path}::#{line}"
  end
end

end #/module Clirtest
