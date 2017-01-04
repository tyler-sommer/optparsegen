class OptParseGen::ScoptParser
  def initialize(input)
    @tape = input
    @options = []
    @current = OptParseGen::Option.new
  end

  def parse
    state = :parse_any

    while state != nil
      lchomp_until!(is_not_space)
      state = send(state)
    end

    @options
  end

  private
  def is_not_space
    /[^\s]/
  end
  
  def is_space
    /\s/
  end

  def lchomp_until!(matches)
    p = @tape.index(matches)
    if p == nil
      @tape.slice!(-1)
    else
      @tape.slice!(0, p)
    end
  end

  def parse_any
    case
      when @tape.start_with?('-') then
        @tape.slice!(0, 1)
        :parse_opt
      when (p = @tape.index("\n")) != nil then
        @tape.slice!(0, p)
        :parse_any
      else
        nil
    end
  end

  def parse_opt
    if @tape[0] == '-'
      @tape.slice!(0)
      :parse_opt_name
    else
      :parse_opt_short
    end
  end

  def parse_opt_short
    short = lchomp_until!(is_space).chop!
    if short
      @current.short = short
      :parse_any
    else
      raise 'expected short option name'
    end
  end

  def parse_opt_name
    name = lchomp_until!(is_space)
    if name
      @current.name = name
      :parse_opt_value_or_desc
    else
      raise 'expected option name'
    end
  end

  def parse_opt_value_or_desc
    if @tape.start_with?('<')
      :parse_opt_value
    else
      :parse_opt_desc
    end
  end

  def parse_opt_value
    value = lchomp_until!(is_space)
    if value
      # TODO: Handle value examples.
      # @current.value = value
      :parse_opt_desc
    else
      raise 'expected value'
    end
  end

  def parse_opt_desc
    desc = lchomp_until!("\n")
    if desc
      @current.description = desc
      @options.push(@current)
      @current = OptParseGen::Option.new
      :parse_any
    else
      raise 'expected description'
    end
  end
end
