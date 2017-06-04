require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/invoice_item'
require_relative '../lib/sales_engine'

class InvoiceItemTest < Minitest::Test

  attr_reader :invoice_item

  def setup
    csv_paths = {
                        :items     => "./test/data/small_item_set.csv",
                        :merchants => "./test/data/merchant_sample.csv",
                        :invoices => "./test/data/medium_invoice_set.csv",
                        :invoice_items => "./test/data/medium_invoice_item_set.csv",
                        :transactions => "./test/data/medium_transaction_set.csv",
                        :customers => "./test/data/medium_customer_set.csv"
                      }

    engine = SalesEngine.from_csv(csv_paths)
    repository = engine.invoice_items

    @invoice_item = InvoiceItem.new({
                                      id: '90',
                                      item_id: '263547180',
                                      invoice_id: '18',
                                      quantity: '5',
                                      unit_price: '46317',
                                      created_at: '2012-03-27 14:54:09 UTC',
                                      updated_at: '2012-03-27 14:54:09 UTC'
                                      }, repository)
  end

  def test_it_exists
    assert_instance_of InvoiceItem, invoice_item
  end

  def test_it_has_an_id
    assert_equal 90, invoice_item.id
  end

  def test_it_knows_item_id
    assert_equal 263547180, invoice_item.item_id
  end

  def test_it_knows_invoice_id
    assert_equal 18, invoice_item.invoice_id
  end

  def test_it_knows_quantity
    assert_equal '5', invoice_item.quantity
  end

  def test_it_has_a_unit_price
    assert_instance_of BigDecimal, invoice_item.unit_price
    assert_equal 463.17, invoice_item.unit_price
  end

  def test_it_knows_when_it_was_created_and_updated
    assert_instance_of Time, invoice_item.created_at
    assert_instance_of Time, invoice_item.updated_at
  end

  def test_it_can_convert_to_dollars
    assert_instance_of Float, invoice_item.unit_price_to_dollars
    assert_equal 463.17, invoice_item.unit_price_to_dollars
  end

  def test_it_knows_about_parent_repo
    assert_instance_of InvoiceItemRepository, invoice_item.repository
  end
end
