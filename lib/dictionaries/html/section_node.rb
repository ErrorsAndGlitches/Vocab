class SectionNode
  def initialize(sn_text)
    @sn_symbols = sn_text.strip.split(/\W+/)
  end

  def is_first
    @sn_symbols.size > 0 && @sn_symbols[-1] =~ /[1aA]/
  end

  def required_depth
    case @sn_symbols[-1]
      when /\d+/
        1
      when /[a-z]/
        2
      else
        raise Exception.new("Unrecognized top section type: #{@sn_symbols[-1]}")
    end
  end
end