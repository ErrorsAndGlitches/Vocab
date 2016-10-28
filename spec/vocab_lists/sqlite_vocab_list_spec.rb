require 'rspec'

require_relative '../../lib/vocab_lists/sqlite_vocab_list'
require_relative '../../lib/vocab_lists/vocab_word'

describe SqliteVocabList.class.to_s do
  describe 'when given a file name and told to create the table' do
    it 'should should create the table' do
      test_db_filename  = 'test_db_filename.sqlite3'
      sqlite_vocab_list = SqliteVocabList.new(test_db_filename, false)
      sqlite_vocab_list.create_table
      sqlite_vocab_list.close

      expect(File.exists?(test_db_filename)).to eq true
      File.delete(test_db_filename)
    end
  end

  describe 'when given a vocab word to insert and remove in the DB' do
    it 'should make the word available in the list after insert and not after remove' do
      test_db_filename  = 'test_db_filename.sqlite3'
      sqlite_vocab_list = SqliteVocabList.new(test_db_filename, false)
      sqlite_vocab_list.create_table

      sqlite_vocab_list.add_vocab_words([VocabWord.new('word', 'definition', 'example')])
      expect(sqlite_vocab_list.vocab_words.size).to eq 1

      sqlite_vocab_list.remove('word')
      expect(sqlite_vocab_list.vocab_words.size).to eq 0

      sqlite_vocab_list.close

      expect(File.exists?(test_db_filename)).to eq true
      File.delete(test_db_filename)
    end
  end

  describe 'when given a non-empty db then a clear of the db' do
    it 'should remove all the words in the db' do
      test_db_filename  = 'test_db_filename.sqlite3'
      sqlite_vocab_list = SqliteVocabList.new(test_db_filename, false)
      sqlite_vocab_list.create_table

      sqlite_vocab_list.add_vocab_words([VocabWord.new('word', 'definition', 'example')])
      sqlite_vocab_list.add_vocab_words([VocabWord.new('word_2', 'definition_2', 'example_2')])
      expect(sqlite_vocab_list.vocab_words.size).to eq 2

      sqlite_vocab_list.clear
      expect(sqlite_vocab_list.vocab_words.size).to eq 0

      sqlite_vocab_list.close

      expect(File.exists?(test_db_filename)).to eq true
      File.delete(test_db_filename)
    end
  end
end
