class AnkiNoteCards
  def initialize(vocab_words, delimiter)
    @vocab_words = vocab_words
    @delimiter = delimiter
  end

  def write(output_file)
    @vocab_words.each { |vocab_word|
      output_file.write("#{vocab_word.word} #{@delimiter} #{vocab_word.definition} #{@delimiter} #{vocab_word.example}\n")
    }
  end
end