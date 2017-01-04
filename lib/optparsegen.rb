# The main entry point for OptParseGen.
class OptParseGen
  # Represents a single option.
  Option = Struct.new(:name, :short, :description)

  # Generates 'optparse' code from the given input and format.
  def self.generate(input, format)
    require "optparsegen/#{format}"
    parser = OptParseGen.const_get("#{format.capitalize}Parser").new(input)
    options = parser.parse
    puts options
  end
end
