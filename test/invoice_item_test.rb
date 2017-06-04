require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/invoice_item'
require_relative '../lib/sales_engine'

class InvoiceItemTest < Minitest::Test

  attr_reader :invoice_item

  def setup
    small_csv_paths = { :invoice_items => './test/data/medium_invoice_item_set.csv'
      }

    # engine = SalesEngine.from_csv(small_csv_paths)
    csv  = CSV.open './test/data/medium_invoice_item_set.csv', headers: true, header_converters: :symbol

    @invoice_item = InvoiceItem.new({
                                      :id => '90',
                                      :item_id => '263547180',
                                      :invoice_id => '18',
                                      :quantity => '5',
                                      :unit_price => '263547180',
                                      :created_at => '2012-03-27 14:54:10',
                                      :updated_at => '2012-03-27 14:54:10'
                                    })
  end

  def test_it_exists
    assert_instance_of InvoiceItem, invoice_item
  end

  def test_it_has_an_id
    assert_equal '90', invoice_item.id
  end
end
