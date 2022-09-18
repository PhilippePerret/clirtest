# encoding: UTF-8
class Logger

  attr_reader :logs, :errors

  ##
  # Afficher (mode verbeux)
  # ou Consigner (mode test)
  # ou consigner dans un fichier (mode silencieux)
  # le message +msg+
  #
  def log(msg, color_method = nil, params = nil)
    params ||= {}
    if test?
      @logs << {message:msg, colo: :color_method}
    elsif verbose? || params[:force]
      msg = msg.send(color_method) if color_method
      puts(msg)
    else
      LOGGER.in_file(msg)
    end  
  end

  ##
  # Afficher (ou enregistrer un message d'erreur)
  #
  def error(msg)
    if test?
      @errors << {message:msg, color: :rouge}
    else
      log(msg, :rouge)
      verbose? || puts(msg.rouge)
    end
  end

  ##
  # À chaque appel de commande, on doit réinitialiser
  # les messages et les erreurs. Cela est très utile pour
  # les tests par exemple
  def reset
    @errors = []
    @logs   = [] 
  end

  def in_file(msg)
    @ref ||= File.open(log_path,'a')
    @ref.puts "#{Time.now.strftime(FMT_DATE_HEURE)} #{msg}"
  end
  def log_path
    @log_path ||= File.join(APP_FOLDER,'mycron.log')
  end
end #/Logger
LOGGER = Logger.new

def log(msg, params = {couleur: :bleu, force: false})
  LOGGER.log(msg, params[:couleur], params)
end

def log_success(msg)
  LOGGER.log(msg, :vert)
  return true
end

# Ce message est toujours affiché à la console, que le mode
# verbeux soit en route ou non.
def log_error(msg)
  msg = "ERROR: #{msg}"
  LOGGER.error(msg)
  return false
end

def log_minor_error(msg)
  LOGGER.log("MINOR ERROR: #{msg}",:orange)
  return false
end

def log_notice(msg)
  LOGGER.log("NOTICE: #{msg}", :gris)
end

