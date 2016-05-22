require 'abstraction'

class DefinitionTextNode
  def initialize(dt_text_node)
    @dt_node = dt_text_node
  end

  def text
    ColonToSemiColonTransform.new(
      ColonlessBeginningTransform.new(
        SxToCommaDelimitationTransform.new(
          RemoveSxnTransform.new(
            RemoveQuotesTransform.new(@dt_node).node
          ).node
        ).node.text
      ).colonless_text
    ).text.strip
  end

  private

  class ColonlessBeginningTransform
    def initialize(text)
      @text =text
    end

    def colonless_text
      @text.sub(/\s*:/, '')
    end
  end

  class SxToCommaDelimitationTransform
    def initialize(node)
      @node = node
    end

    def node
      @node.xpath('./sx')[0..-2].each { |sx_node|
        sx_node.content = "#{sx_node.content},"
      }
      @node
    end
  end

  class RemoveQuotesTransform
    def initialize(node)
      @node = node
    end

    def node
      @node.xpath('.//vi').each { |quote_node| quote_node.remove }
      @node
    end
  end

  class RemoveSxnTransform
    def initialize(node)
      @node = node
    end

    def node
      @node.xpath('.//sxn').each { |sxn_node| sxn_node.remove }
      @node
    end
  end

  class ColonToSemiColonTransform
    def initialize(text)
      @text = text
    end

    def text
      @text.gsub(/ :/, '; ').gsub(/:/, ';')
    end
  end
end
