#!/usr/bin/env ruby
require 'optparse'

options = OptionParser.new do |opts|
  opts.banner = %Q(Usage: #{File.basename($0)} [options] <file>

optparsegen converts program usage text into equivalent ruby 'optparse'
code. It reads the text from the filename passed as the only argument
on the command line or from standard input.

Options:
)

  opts.on_tail('h', '--help', 'Show this message.') do
    puts opts
    exit
  end
end

options.parse!


input = ARGF.read
state = :parse

def is_not_space
  /[^\s]/
end
def is_space
  /\s/
end

def lchomp_until!(tape, matches)
  p = tape.index(matches)
  if p == nil
    tape.slice!(-1)
  else
    tape.slice!(0, p)
  end
end

def parse(tape)
  case
    when tape.start_with?('-') then
      tape.slice!(0, 1)
      :parse_opt
    when (p = tape.index("\n")) != nil then
      puts "eating: #{p} #{tape.slice!(0, p)}"
      :parse
    else
      nil
  end
end

def parse_opt(tape)
  if tape[0] == '-'
    tape.slice!(0)
    :parse_opt_name
  else
    :parse_opt_short
  end
end

def parse_opt_short(tape)
  short = lchomp_until!(tape, is_space).chop!
  if short
    puts "Found a short option '#{short}'"
    :parse
  else
    puts 'expected short option name'
    nil
  end
end

def parse_opt_name(tape)
  name = lchomp_until!(tape, is_space)
  if name
    puts "Found an option named '#{name}'"
    :parse_opt_value_or_desc
  else
    puts 'expected option name'
    nil
  end
end

def parse_opt_value_or_desc(tape)
  if tape.start_with?('<')
    :parse_opt_value
  else
    :parse_opt_desc
  end
end

def parse_opt_value(tape)
  value = lchomp_until!(tape, is_space)
  if value
    puts "Found a value '#{value}'"
    :parse_opt_desc
  else
    puts 'expected value'
    nil
  end
end

def parse_opt_desc(tape)
  desc = lchomp_until!(tape, "\n")
  if desc
    puts "Found a desc '#{desc}'"
    :parse
  else
    puts 'expected description'
    nil
  end
end

while state != nil
  lchomp_until!(input, is_not_space)
  state = send(state, input)
end