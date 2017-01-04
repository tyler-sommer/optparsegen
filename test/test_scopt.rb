require 'minitest/autorun'
require 'optparsegen'
require 'optparsegen/scopt'

class ScoptParserTest < Minitest::Test
  def test_basic_parse
    input = 'Usage: myprogram [options]

  --help                   Shows this usage text.
  -d, --work-date <value>  Generate data for this date. Default: 2017-01-02
  -i, --input-dir <value>  Load input data from this directory. Default: hdfs:///path/to/input
  -o, --output-dir <value>
                           Output generated data to this directory. Default: hdfs:///path/to/output
  -x, --extra-jars <jar1>,<jar2>...
                           Extra jars to include.
'

    options = parse(input)

    assert_equal(5, options.size)
    assert_equal('extra-jars help input-dir output-dir work-date', options.map { |o| o.name }.sort.join(' '))
    assert_equal('Extra jars to include.', options.find { |o| o.name == 'extra-jars' }.description)
  end

  def test_parse_error
    input = 'Usage: myprogram [options]

  --help
'
    err = assert_raises RuntimeError do
      parse(input)
    end
    assert_equal('expected description', err.message)
  end

  private
  def parse(input)
    OptParseGen::ScoptParser.new(input).parse
  end
end