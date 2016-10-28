require 'sqlite3'

require_relative 'vocab_word'
require_relative 'vocab_list'

class KindleSqliteVocabList < VocabList
  def initialize(db_filename)
    @db = SQLite3::Database.new(db_filename)
  end

  def vocab_words
    @db.execute('SELECT word, usage, lookups.timestamp FROM words JOIN lookups on words.id = lookups.word_key GROUP BY word ORDER BY lookups.timestamp ASC').map { |row|
      VocabWord.new(row[0], '', row[1])
    }
  end
end