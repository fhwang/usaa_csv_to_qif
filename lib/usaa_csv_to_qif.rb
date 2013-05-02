require 'rubygems'
require 'bundler/setup'

require 'csv'
require 'stringio'
require 'qif'
require 'qif/writer'

module UsaaCsvToQif
  def self.convert(input_csv)
    buffer = StringIO.new
    writer = Qif::Writer.new buffer
    begin
      CSV.parse(input_csv) do |row|
        writer << transaction_from_csv_row(row)
      end
    rescue CSV::MalformedCSVError
      # USAA's CSV files consistently fail on the last line for some reason
    end
    writer.write
    buffer.rewind
    buffer.read
  end

  def self.transaction_from_csv_row(row)
    attrs = {
      date: row[2], amount: row[6], memo: row[5], payee: row[4], 
      number: row[3]
    }
    Qif::Transaction.new(attrs)
  end
end
