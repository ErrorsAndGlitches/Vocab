require 'sqlite3'

class SqliteVocabList < VocabList
  def initialize(sqlite_filename, should_update_existing)
    @sqlite_db              = SQLite3::Database.new(sqlite_filename)
    @should_update_existing = should_update_existing
  end

  def create_table
    begin
      vocab_words(1)
      puts 'Table exists...'
    rescue
      puts 'Creating table...'
      @sqlite_db.execute('CREATE TABLE words(
        word VARCHAR(255) NOT NULL,
        definition TEXT NOT NULL,
        example TEXT NOT NULL,
        PRIMARY KEY(word)
      )')
    end
  end

  def vocab_words(limit = nil)
    limit_constraint = limit.nil? ? '' : "LIMIT #{limit}"
    vocab_word_list = []
    @sqlite_db.execute('SELECT * FROM words ' + limit_constraint) { |row|
      vocab_word_list <<= VocabWord.new(row[0], row[1], row[2])
    }
    vocab_word_list
  end

  def add_vocab_words(vocab_words)
    if @should_update_existing
      update_vocab_words(vocab_words)
    else
      insert_vocab_words(vocab_words)
    end
  end

  def remove(word)
    @sqlite_db.execute("DELETE FROM words WHERE word='#{word}'")

    num_words = 0
    @sqlite_db.execute("SELECT * FROM words WHERE word='#{word}'") {
      num_rows += 1
    }

    if num_words == 0
      puts "Successfully deleted: #{word}"
    else
      puts "Failed to delete: #{word}"
      exit 1
    end
  end

  def clear
    @sqlite_db.execute('DELETE FROM words')
  end

  def close
    @sqlite_db.close
  end

  private

  def insert_vocab_words(vocab_words)
    insert_statement = @sqlite_db.prepare('INSERT INTO words (word, definition, example) VALUES(?, ?, ?)')
    vocab_words.each { |vocab_word|
      begin
        insert_statement.execute(vocab_word.word, vocab_word.definition, vocab_word.example)
        puts "Inserted: #{vocab_word.word}"
      rescue SQLite3::Exception => e
        puts "Unable to insert '#{vocab_word.word}': #{e}"
      end
    }
    insert_statement.close
  end

  def update_vocab_words(vocab_words)
    update_statement = @sqlite_db.prepare('REPLACE INTO words (word, definition, example) VALUES(?, ?, ?)')
    vocab_words.each { |vocab_word|
      begin
        update_statement.execute(vocab_word.word, vocab_word.definition, vocab_word.example)
        puts "Inserted or updated: #{vocab_word.word}"
      rescue SQLite3::Exception => e
        puts "Unable to insert or update '#{vocab_word.word}': #{e}"
      end
    }
    update_statement.close
  end
end
