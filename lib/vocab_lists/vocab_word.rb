class VocabWord
  attr_reader :word, :definition, :example

  def initialize(word, definition, example)
    @word = word
    @definition = definition
    @example = example
  end

  def is_defined?
    !@definition.nil? && !@definition.strip.empty?
  end
end