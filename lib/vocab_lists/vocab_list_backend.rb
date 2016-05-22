require 'abstraction'

class VocabListBackend
  abstract

  def vocab_words
    raise Exception.new('vocab_words() not implemented')
  end

  def add_vocab_words(vocab_words)
    raise Exception.new('add_vocab_words(vocab_words) not implemented')
  end

  def clear
    raise Exception.new('clear() not implemented')
  end
end