require_relative '../../lib/dictionaries/merriam_webster_dictionary'

RSpec.describe MerriamWebsterDictionary do
  context 'when parsing the response from a dictionaryapi call for palatable' do
    it 'should return the list of definition for palatable' do
      dictionary = MerriamWebsterDictionary.new('api_key')

      expect(dictionary).to receive(:open)
                              .and_return(File.open('spec/data/palatable_definition.xml'))

      # make sure that the file is opened instead of a network call
      definition = dictionary.definition('this is not a word')
      expect(definition).to eq '<p>'\
        '<ol type="1">'\
          '<li>agreeable to the palate or taste</li>'\
          '<li>agreeable or acceptable to the mind</li>'\
        '</ol></p>'
    end
  end

  context 'when parsing the response from a dictionaryapi call for quail' do
    it 'should return the list of definition for quail' do
      dictionary = MerriamWebsterDictionary.new('api_key')

      expect(dictionary).to receive(:open)
                              .and_return(File.open('spec/data/quail_definition.xml'))

      # make sure that the file is opened instead of a network call
      definition = dictionary.definition('this is not a word')

      def_one = '<p>any of numerous small gallinaceous birds; as'\
      '<ol type="1"><li><ol type="a">'\
        '<li>an Old World migratory game bird (Coturnix coturnix)</li>'\
        '<li>bobwhite</li>'\
      '</ol></li></ol></p>'

      def_two = '<p>'\
        '<ol type="1">'\
          '<li><ol type="a">'\
            '<li>wither, decline</li>'\
            '<li>to give way; falter</li>'\
          '</ol></li>'\
          '<li>to recoil in dread or terror; cower</li>'\
          '<li>to make fearful</li>'\
        '</ol></p>'

      def_three = '<p>'\
          'any of a family (Turnicidae) of small terrestrial Old World birds that resemble quails and have only three toes on a foot with the hind toe being absent'\
        '</p>'

      def_four = '<p>'\
          'a quail (Coturnix japonica syn. C. coturnix japonica) of eastern Asia that is sometimes raised for its meat or eggs and is used in laboratory research'\
        '</p>'

      expect(definition).to eq [def_one, def_two, def_three, def_four].join('')
    end
  end

  context 'when parsing the response from a dictionaryapi call for percolating' do
    it 'should return the list of definition for percolating' do
      dictionary = MerriamWebsterDictionary.new('api_key')

      expect(dictionary).to receive(:open)
                              .and_return(File.open('spec/data/percolating_definition.xml'))

      # make sure that the file is opened instead of a network call
      definition = dictionary.definition('this is not a word')
      expect(definition).to eq '<p>'\
        '<ol type="1">'\
          '<li><ol type="a">'\
            '<li>to cause (a solvent) to pass through a permeable substance (as a powdered drug) especially for extracting a soluble constituent</li>'\
            '<li>to prepare (coffee) in a percolator</li>'\
          '</ol></li>'\
          '<li>to be diffused through; penetrate</li>'\
        '</ol>'\
        '<ol type="1">'\
          '<li>to ooze or trickle through a permeable substance; seep</li>'\
          '<li><ol type="a">'\
            '<li>to become percolated</li>'\
            '<li>to become lively or effervescent</li>'\
          '</ol></li>'\
          '<li>to spread gradually</li>'\
          '<li>simmer</li>'\
        '</ol></p>'
    end
  end

  context 'when parsing the response from a dictionaryapi call for romped' do
    it 'should return the list of definition for romped' do
      dictionary = MerriamWebsterDictionary.new('api_key')

      expect(dictionary).to receive(:open)
                              .and_return(File.open('spec/data/romped_definition.xml'))

      # make sure that the file is opened instead of a network call
      definition = dictionary.definition('this is not a word')
      expect(definition).to eq '<p>'\
        '<ol type="1">'\
          '<li>to run or play in a lively, carefree, or boisterous manner</li>'\
          '<li>to move or proceed in a brisk, easy, or playful manner</li>'\
          '<li>to win a contest easily</li>'\
        '</ol></p>'
    end
  end

  context 'when parsing the response from a dictionaryapi call for maw' do
    it 'should return the list of definition for maw' do
      dictionary = MerriamWebsterDictionary.new('api_key')

      expect(dictionary).to receive(:open)
                              .and_return(File.open('spec/data/maw_definition.xml'))

      # make sure that the file is opened instead of a network call
      definition = dictionary.definition('this is not a word')
      expect(definition).to eq '<p>'\
        '<ol type="1">'\
          '<li>the receptacle into which food is taken by swallowing;</li>'\
          '<li><ol type="a">'\
              '<li>stomach</li>'\
              '<li>crop</li>'\
          '</ol></li>'\
          '<li><ol type="a">'\
            '<li>the throat, gullet, or jaws especially of a voracious animal</li>'\
            '<li>something suggestive of a gaping maw</li>'\
          '</ol></li>'\
        '</ol></p>'
    end
  end
end
