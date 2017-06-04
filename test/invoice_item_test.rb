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
                                      :unit_price => '46317',
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

  def test_it_knows_item_id
    assert_equal '263547180', invoice_item.item_id
  end

  def test_it_knows_invoice_id
    assert_equal '18', invoice_item.invoice_id
  end

  def test_it_knows_quantity
    assert_equal '5', invoice_item.quantity
  end

  def test_it_has_a_unit_price
    assert_instance_of BigDecimal, invoice_item.unit_price
    assert_equal 463.17, invoice_item.unit_price
  end
end
