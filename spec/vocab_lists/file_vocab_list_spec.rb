require_relative '../../lib/vocab_lists/file_vocab_list'

describe FileVocabList do
  context 'when given a vocab file' do
    it 'should return a list of the vocabulary words' do
      vocab_file = FileVocabList.new('spec/data/kindle_vocab_words.txt', ':')
      words      = vocab_file.vocab_words
      check_word(words[0], 'word_1', 'definition_1', 'example_1')
      check_word(words[1], 'word_2', 'definition_2', 'example_2')
    end

    it 'should successfully append words' do
      file_name = 'vocab_file_name.txt'
      file      = double('vocab file')
      words     = [double('vocab word', :word => 'word', :definition => 'definition', :example => 'example')]

      expect(File).to receive(:open).with(file_name, 'a').once.and_yield(file)
      expect(file).to receive(:write).with('word : definition : example').once

      vocab_file = FileVocabList.new(file_name, ':')
      vocab_file.add_vocab_words(words)
    end
  end

  def check_word(vocab_word, word, definition, example)
    expect(vocab_word.word).to eq word
    expect(vocab_word.definition).to eq definition
    expect(vocab_word.example).to eq example
  end
end