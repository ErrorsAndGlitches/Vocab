require_relative 'dictionary'

class MultiDictionary < Dictionary
  def initialize(dictionaries)
    @dictionaries = dictionaries
  end

  def definition(word)
    @dictionaries.each { |dictionary|
      word_def = dictionary.definition(word)
      return word_def unless word_def.nil?
    }
  end
end