require 'nokogiri'

require_relative 'dictionary'
require_relative 'html/section_node'
require_relative 'html/definition_text_node'

class MerriamWebsterDictionary < Dictionary
  def initialize(api_key)
    @api_key = api_key
  end

  def definition(word)
    url  = "http://www.dictionaryapi.com/api/v1/references/collegiate/xml/#{word}?key=#{@api_key}"
    page = Nokogiri::XML(open(url)) { |config|
      config.options = Nokogiri::XML::ParseOptions::NOBLANKS
    }

    defs = page.xpath('//def')
      .map { |def_xml_node| OnlyDtSnNodes.new(def_xml_node).node }
      .map { |clean_def_xml_node| HtmlDefinition.new(clean_def_xml_node).html }
      .map { |html_doc| html_doc }
      .join('')

    puts "FETCH (Merriam Webster Dictionary): #{word}: #{defs}"
    defs
  end

  private

  class OnlyDtSnNodes
    def initialize(def_xml_node)
      @def_xml_node = def_xml_node
    end

    def node
      @def_xml_node.children.each { |child_node|
        child_node.remove unless child_node.name == 'dt' || child_node.name == 'sn'
      }
      @def_xml_node
    end
  end

  class HtmlDefinition
    def initialize(clean_def_xml_node)
      @clean_def_xml_node = clean_def_xml_node
    end

    def html
      @html_str ||= html_definition
    end

    private

    def html_definition
      @list_nesting_depth = 0

      @section_type_stack = []
      @html_doc           = Nokogiri::HTML::Document.new
      root_node           = Nokogiri::XML::Node.new('p', @html_doc)
      @html_doc.add_child(root_node)
      @html_doc_pointer = root_node

      @clean_def_xml_node.children.each { |child_node|
        case child_node.name
          when 'sn'
            ingest_section(child_node)
          when 'dt'
            ingest_definition_text(child_node)
          else
            raise Exception.new("Unrecognized node type: #{child_node.name}")
        end
      }

      HtmlString.new(@html_doc).to_s
    end

    def ingest_section(child_node)
      section = SectionNode.new(child_node.text)
      set_html_doc_pointer(section)
    end

    def set_html_doc_pointer(section)
      if section.required_depth > @list_nesting_depth
        (@list_nesting_depth ... section.required_depth).each {
          push_html_list
        }
      elsif section.required_depth < @list_nesting_depth
        (section.required_depth ... @list_nesting_depth).each {
          pop_html_list
        }

        if section.is_first
          pop_html_list
          push_html_list
        end
      else
        if section.is_first
          pop_html_list
          push_html_list
        end
      end
    end

    def push_html_list
      if @list_nesting_depth > 0
        node = Nokogiri::XML::Node.new('li', @html_doc)
        @html_doc_pointer.add_child(node)
        @html_doc_pointer = node
      end

      node         = Nokogiri::XML::Node.new('ol', @html_doc)
      node['type'] = section_type
      @html_doc_pointer.add_child(node)
      @html_doc_pointer   = node
      @list_nesting_depth += 1
    end

    def pop_html_list
      @html_doc_pointer   = @list_nesting_depth == 1 ? @html_doc_pointer.parent : @html_doc_pointer.parent.parent
      @list_nesting_depth -= 1
    end

    def section_type
      case @list_nesting_depth
        when 0
          '1'
        when 1
          'a'
        else
          raise Exception.new("Unknown depth for current listing depth of #{@list_nesting_depth}")
      end
    end

    def ingest_definition_text(child_node)
      if @list_nesting_depth == 0
        node = Nokogiri::XML::Text.new(DefinitionTextNode.new(child_node).text, @html_doc)
        @html_doc_pointer.add_child(node)
      else
        node         = Nokogiri::XML::Node.new('li', @html_doc)
        node.content = DefinitionTextNode.new(child_node).text
        @html_doc_pointer.add_child(node)
      end
    end
  end

  class HtmlString
    def initialize(html_doc)
      @html_doc = html_doc
    end

    def to_s
      @html_doc.to_html(:save_with => 0)
        .split(/\n/)[1] # nokogiri saving creates the DOCTYPE in line 0 and the HTML in line 1
    end
  end
end