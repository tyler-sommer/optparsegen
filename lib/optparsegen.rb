require 'erb'

# The main entry point for OptParseGen.
class OptParseGen
  # Represents a single option.
  Option = Struct.new(:name, :short, :description) do
    def underscored_name
      name.sub('-', '_')
    end

    def symbol_name
      ":#{underscored_name}"
    end

    def opt_args
      args = []
      args.push "--#{name}" if name
      args.push "-#{short}" if short
      args.push description if description
      args
    end
  end

  # An ERB based renderer.
  class Renderer
    def self.render(options)
      ERB.new(%Q(require 'optparse'

options = Struct.new(<%= options.map { |o| o.symbol_name }.join(', ') %>).new

OptionParser.new do |opts|
<% for o in options.select { |o| o.name != "help" } %>
  opts.on(<%= o.opt_args.map { |arg| "'\#{arg}'" }.join(', ') %>) do |v|
    options.<%= o.underscored_name %> = v
  end

<% end %>
  opts.on_tail('-h', '--help', 'Shows this usage text.') do
    puts opts
    exit
  end
end.parse!
), 0, '>').result(binding)
    end
  end

  # Generates 'optparse' code from the given input and format.
  def self.generate(input, format)
    require "optparsegen/#{format}"
    parser = OptParseGen.const_get("#{format.capitalize}Parser").new(input)
    options = parser.parse
    Renderer.render(options)
  end
end
