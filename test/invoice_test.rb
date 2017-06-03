require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/invoice'
# require_relative '../lib/invoice_repository'
require_relative '../lib/sales_engine'
class InvoiceTest < Minitest::Test
  attr_reader :invoice
  def setup
    small_csv_paths = {
                        :items     => "./test/data/medium_item_set.csv",
                        :merchants => "./test/data/merchant_sample.csv",
                        :invoices => "./test/data/medium_invoice_set.csv"
                      }
    engine = SalesEngine.from_csv(small_csv_paths)
    csv  = CSV.open './test/data/small_item_set.csv', headers: true, header_converters: :symbol
    repository = engine.invoices
    @invoice = Invoice.new({
                            :id => "17",
                            :customer_id => "5",
                            :merchant_id => "12334112",
                            :status => "pending",
                            :created_at => "2005-06-03",
                            :updated_at => "2015-07-01"
                          }, repository)
  end

  def test_it_exists
    assert_instance_of Invoice, invoice
  end

  def test_it_has_an_id
    assert_equal 17, invoice.id
  end

  def test_it_knows_its_customer_id
    assert_equal 5, invoice.customer_id
  end

  def test_it_knows_its_merchant_id
    assert_equal 12334112, invoice.merchant_id
  end

  def test_it_has_a_status
    assert_equal "pending", invoice.status
  end

  def test_it_knows_when_it_was_created_and_updated
    assert_instance_of Time, invoice.created_at
    assert_instance_of Time, invoice.updated_at
  end

  def test_it_knows_about_parent_repo
    assert_instance_of InvoiceRepository, invoice.repository
  end

  def test_it_can_get_its_merchant
    actual = invoice.merchant

    assert_instance_of Merchant, actual
    assert_equal 12334112, actual.id
  end
end
