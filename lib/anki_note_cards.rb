class AnkiNoteCards
  def initialize(vocab_words)
    @vocab_words = vocab_words
    @delimiter = '^'
  end

  def write(output_filename)
    File.open(output_filename, 'w') { |output_file|
      @vocab_words.each { |vocab_word|
        output_file.write("#{vocab_word.word} #{@delimiter} #{vocab_word.definition} #{@delimiter} #{vocab_word.example}\n")
      }
    }
  end
end