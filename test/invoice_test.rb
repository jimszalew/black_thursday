require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/invoice'
# require_relative '../lib/invoice_repository'
require_relative '../lib/sales_engine'
class InvoiceTest < Minitest::Test
  attr_reader :invoice,
              :invoice2,
              :invoice3
  def setup
    csv_paths = {
                        :items     => "./test/data/medium_item_set.csv",
                        :merchants => "./test/data/merchant_sample.csv",
                        :invoices => "./test/data/medium_invoice_set.csv",
                        :invoice_items => "./test/data/medium_invoice_item_set.csv",
                        :transactions => "./test/data/medium_transaction_set.csv",
                        :customers => "./test/data/medium_customer_set.csv"
                      }

    engine = SalesEngine.from_csv(csv_paths)
    repository = engine.invoices

    @invoice = Invoice.new({
                            :id => "3",
                            :customer_id => "5",
                            :merchant_id => "12334112",
                            :status => "pending",
                            :created_at => "2005-06-03",
                            :updated_at => "2015-07-01"
                          }, repository)

    @invoice2 = Invoice.new({
                            :id => "46",
                            :customer_id => "21",
                            :merchant_id => "12334112",
                            :status => "pending",
                            :created_at => "2005-06-03",
                            :updated_at => "2015-07-01"
                          }, repository)

    @invoice3 = Invoice.new({
                            :id => "1",
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
    assert_equal 3, invoice.id
  end

  def test_it_knows_its_customer_id
    assert_equal 5, invoice.customer_id
  end

  def test_it_knows_its_merchant_id
    assert_equal 12334112, invoice.merchant_id
  end

  def test_it_has_a_status
    assert_equal :pending, invoice.status
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

  def test_it_can_get_its_items
    actual = invoice.items

    assert_instance_of Array, actual
    assert_instance_of Item, actual.sample
    assert_equal 1, actual.count
  end

  def test_it_can_get_its_transactions
    actual = invoice2.transactions

    assert_instance_of Array, actual
    assert_instance_of Transaction, actual.sample
    assert_equal 1, actual.count
  end

  def test_it_can_get_its_customer
    actual = invoice2.customer

    assert_instance_of Customer, actual
    assert_equal 21, actual.id
  end

  def test_it_knows_if_invoice_is_paid_in_full
    assert invoice2.is_paid_in_full?
    refute invoice.is_paid_in_full?
  end

  def test_it_can_its_invoice_items
    actual = invoice.invoice_items

    assert_instance_of Array, actual
    assert_instance_of InvoiceItem, actual.sample
    assert_equal 8, actual.count
  end

  def test_it_can_calculate_invoice_total
    csv_paths = {
                        :items     => "./data/items.csv",
                        :merchants => "./data/merchants.csv",
                        :invoices => "./data/invoices.csv",
                        :invoice_items => "./data/invoice_items.csv",
                        :transactions => "./data/transactions.csv",
                        :customers => "./data/customers.csv"
                      }

    engine = SalesEngine.from_csv(csv_paths)
    repository = engine.invoices

    invoice3 = Invoice.new({
                            :id => "1",
                            :customer_id => "5",
                            :merchant_id => "12334112",
                            :status => "pending",
                            :created_at => "2005-06-03",
                            :updated_at => "2015-07-01"
                          }, repository)
                          
    assert_equal 21067.77, invoice3.total
  end

  def test_total_returns_nil_if_invoice_not_paid_in_full
    assert_nil invoice.total
  end
end
