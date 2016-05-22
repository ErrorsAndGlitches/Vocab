require_relative '../lib/vocab_lists/vocab_word'

describe VocabWord do
  context 'when given a word, definition, and example' do
    it 'should return those same values' do
      vocab_word = VocabWord.new('word', 'definition', 'example')
      expect(vocab_word.word).to eq 'word'
      expect(vocab_word.definition).to eq 'definition'
      expect(vocab_word.example).to eq 'example'
    end
  end

  context 'when giving an empty definition' do
    it 'should not be defined' do
      vocab_word = VocabWord.new('word', '', 'example')
      expect(vocab_word.is_defined?).to be false

      vocab_word = VocabWord.new('word', nil, 'example')
      expect(vocab_word.is_defined?).to be false
    end
  end
end
