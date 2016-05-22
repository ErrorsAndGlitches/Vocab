require_relative 'vocab_list_backend'
require_relative 'vocab_word'

class FileVocabList < VocabListBackend
  def initialize(file_name)
    @file_name = file_name
  end

  def vocab_words
    IO.readlines(@file_name)
      .map { |line| line.split(':') }
      .map { |word_data|
      VocabWord.new(word_data[0].strip, word_data[1].strip, word_data[2].nil? ? '' : word_data[2].strip)
    }
  end

  def add_vocab_words(vocab_words)
    File.open(@file_name, 'a') { |file|
      vocab_words.each { |vocab_word|
        file.write("#{vocab_word.word} : #{vocab_word.definition} : #{vocab_word.example}")
      }
    }
  end
end