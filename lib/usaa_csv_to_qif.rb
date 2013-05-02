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
        attrs = {
          date: row[2], amount: row[6], memo: row[5], payee: row[4]
        }
        if attrs[:payee] =~ /^CHECK # (\d+)\s*$/
          attrs[:number] = $1.to_i
        end
        writer << Qif::Transaction.new(attrs)
      end
    rescue CSV::MalformedCSVError
      # USAA's CSV files consistently fail on the last line for some reason
    end
    writer.write
    buffer.rewind
    buffer.read
  end
end
