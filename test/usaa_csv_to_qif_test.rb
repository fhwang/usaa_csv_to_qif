require 'test/unit'
require './lib/usaa_csv_to_qif'

class UsaaCsvToQifTest < Test::Unit::TestCase
  def test_check_number
    csv = File.read("./test/data/test1.csv")
    qif = UsaaCsvToQif.convert(csv)
    reader = Qif::Reader.new(qif)
    assert_equal(2, reader.transactions.size)
    txn1 = reader.transactions[0]
    assert_equal("1053", txn1.number)
  end
end
