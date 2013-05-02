#!/usr/bin/env ruby

unless ARGV.size == 2
  puts "usaa_csv_to_qif.rb [input csv] [output qif]"
  exit
end

require './lib/usaa_csv_to_qif'

input_file = ARGV.shift
output_file = ARGV.shift
input_csv = File.read(input_file)
output_qif = UsaaCsvToQif.convert(input_csv)
File.open(output_file, 'w') do |f|
  f << output_qif
end
