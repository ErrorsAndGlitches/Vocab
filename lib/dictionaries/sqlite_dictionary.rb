require 'sqlite3'

class SqliteDictionary < Dictionary
  def initialize(sqlite_filename)
    @sqlite_db = SQLite3::Database.new(sqlite_filename)
  end

  def definition(word)
    results = @sqlite_db.execute("SELECT definition FROM words where word='#{word}'")

    if results.count == 0
      nil
    else
      defs = results.first['definition']
      puts "FETCH (SQLite Dictionary): #{word}: #{defs}"
      defs
    end
  end
end