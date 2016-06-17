require 'abstraction'

class VocabList
  abstract

  def vocab_words(limit)
    raise Exception.new('vocab_words() not implemented')
  end

  def add_vocab_words(vocab_words)
    raise Exception.new('add_vocab_words(vocab_words) not implemented')
  end

  def remove(word)
    raise Exception.new('remove(word) not implemented')
  end

  def clear
    raise Exception.new('clear() not implemented')
  end
end