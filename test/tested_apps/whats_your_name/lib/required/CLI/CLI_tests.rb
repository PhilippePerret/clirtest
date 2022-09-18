# encoding: UTF-8
=begin
  Module Cli utile au NewCliTest
=end
module NewCliTest
class Trace
class << self

  def add(app_folder, str)
    @app_folder = app_folder 
    reffile.puts "--- #{str}"
  end

  def reffile
    @reffile ||= begin
      File.delete(tracepath) if File.exist?(tracepath)
      File.open(tracepath,'a')
    end
  end

  def tracepath
    @tracepath ||= File.join(@app_folder,'tests','clitests','clitests_trace.log')
  end
end #/<< self class Trace
end #/class Trace
end #/module NewCliTest


##
# Permet d'enregistrer la trace d'une valeur dans un fichier
# 
def trace(str)
  NewCliTest::Trace.add(APP_FOLDER, str)  
end
