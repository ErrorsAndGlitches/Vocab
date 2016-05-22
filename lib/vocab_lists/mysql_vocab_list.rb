require 'mysql2'

require_relative 'vocab_list_backend'
require_relative 'vocab_word'

class MysqlVocabList < VocabListBackend
  def initialize(mysql_cfg_filename, should_update_existing)
    @mysql                  = Mysql2::Client.new(:default_file => mysql_cfg_filename, :default_group => 'client')
    @should_update_existing = should_update_existing
  end

  def create_table
    begin
      list_items(1)
      puts 'Table exists...'
    rescue
      puts 'Creating table...'
      @mysql.query('CREATE TABLE words(
      word VARCHAR(255) NOT NULL,
      definition TEXT NOT NULL,
      example TEXT NOT NULL,
      PRIMARY KEY(word)
      )')
    end
  end

  def vocab_words(limit = nil)
    limit_constraint = limit.nil? ? '' : "LIMIT #{limit}"
    @mysql.query('SELECT * FROM words ' + limit_constraint).map { |row|
      VocabWord.new(row['word'], row['definition'], row['example'])
    }
  end

  def add_vocab_words(vocab_words)
    if @should_update_existing
      update_vocab_words(vocab_words)
    else
      insert_vocab_words(vocab_words)
    end
  end

  def clear
    @mysql.query('DELETE FROM words')
  end

  private

  def insert_vocab_words(vocab_words)
    vocab_words.each { |vocab_word|
      word       = @mysql.escape(vocab_word.word)
      definition = @mysql.escape(vocab_word.definition)
      example    = @mysql.escape(vocab_word.example)

      begin
        @mysql.query("INSERT INTO words (word, definition, example) VALUES (
        '#{word}',
        '#{definition}',
        '#{example}'
      )")
        puts "Inserted or updated: #{vocab_word.word}"
      rescue Mysql2::Error => e
        puts "Unable to insert '#{vocab_word.word}': #{e}"
      end
    }
  end

  def update_vocab_words(vocab_words)
    vocab_words.each { |vocab_word|
      word       = @mysql.escape(vocab_word.word)
      definition = @mysql.escape(vocab_word.definition)
      example    = @mysql.escape(vocab_word.example)

      @mysql.query("INSERT INTO words (word, definition, example) VALUES (
        '#{word}',
        '#{definition}',
        '#{example}'
      ) ON DUPLICATE KEY UPDATE definition='#{definition}', example='#{example}'")
      puts "Inserted or updated: #{vocab_word.word}"
    }
  end
end