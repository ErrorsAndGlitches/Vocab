require 'abstraction'

class Dictionary
  abstract

  def definition(word)
    raise Exception.new('definition(word) not implemented')
  end
end