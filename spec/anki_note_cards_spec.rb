require_relative '../lib/anki_note_cards'
require_relative '../lib/vocab_lists/vocab_word'

describe AnkiNoteCards do
  context 'when given a list of vocabulary words' do
    it 'should write those vocab words to a file using the specified delimiter' do
      vocab_words = [
        VocabWord.new('word_1', 'def_1', 'example_1'),
        VocabWord.new('word_2', 'def_2', 'example_2'),
        VocabWord.new('word_3', 'def_3', 'example_3')
      ]

      output_string = StringIO.open { |strio|
        anki_note_cards = AnkiNoteCards.new(vocab_words, '&')
        anki_note_cards.write(strio)
        strio.string
      }

      expect(output_string).to eq "word_1 & def_1 & example_1\n"\
        "word_2 & def_2 & example_2\n"\
        "word_3 & def_3 & example_3\n"
    end
  end
end