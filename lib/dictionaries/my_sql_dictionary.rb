require_relative 'dictionary'

class MySqlDictionary < Dictionary
  def initialize(mysql_cfg_filename)
    @mysql                  = Mysql2::Client.new(:default_file => mysql_cfg_filename, :default_group => 'client')
  end

  def definition(word)
    results = @mysql.query("SELECT definition FROM words where word='#{word}'")

    if results.count == 0
      nil
    else
      defs = results.first['definition']
      puts "FETCH (MySQL Dictionary): #{word}: #{defs}"
      defs
    end
  end
end