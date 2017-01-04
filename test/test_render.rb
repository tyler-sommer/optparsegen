require 'minitest/autorun'
require 'optparsegen'

class RenderTest < Minitest::Test
  def test_render
    options = [
        OptParseGen::Option.new('test', 't', 'A description.'),
        OptParseGen::Option.new('another', nil, 'Without a short parameter.')
    ]

    result = OptParseGen::Renderer.render(options)

    assert_equal(%Q(require 'optparse'

options = Struct.new(:test, :another).new

OptionParser.new do |opts|
  opts.on('--test', '-t', 'A description.') do |v|
    options.test = v
  end

  opts.on('--another', 'Without a short parameter.') do |v|
    options.another = v
  end

  opts.on_tail('-h', '--help', 'Shows this usage text.') do
    puts opts
    exit
  end
end.parse!
), result)
  end
end