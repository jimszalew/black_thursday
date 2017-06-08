require_relative 'test_helper'
require_relative '../lib/invoice_repository'
require_relative "../lib/sales_engine"

class InvoiceRepositoryTest < Minitest::Test
  attr_reader :invoice_repo
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

    @invoice_repo = engine.invoices
  end

  def test_it_exists_and_populates_invoices_automatically
    assert_instance_of InvoiceRepository, invoice_repo
    assert_instance_of Invoice, invoice_repo.invoices[invoice_repo.invoices.keys.sample]
    assert_equal 200, invoice_repo.invoices.keys.length
  end

  def test_it_can_add_invoices
    csv = CSV.open './test/data/medium_invoice_set.csv', headers: true, header_converters: :symbol

    invoice_repo.invoices.clear

    invoice_repo.add(csv)
    random_invoice_key = invoice_repo.invoices.keys.sample

    assert_instance_of Invoice, invoice_repo.invoices[random_invoice_key]
  end

  def test_it_can_return_all_invoice_instances
    actual = invoice_repo.all
    assert_equal 200, actual.length
    assert_instance_of Invoice, actual.sample
  end

  def test_it_can_find_invoice_by_id
    id = 13

    assert_instance_of Invoice, invoice_repo.find_by_id(id)
    assert_equal id, invoice_repo.find_by_id(id).id
  end

  def test_returns_nil_for_invalid_id
    id = "2412341234"

    assert_nil invoice_repo.find_by_id(id)
  end

  def test_it_can_find_all_invoices_by_customer_id
    actual = invoice_repo.find_all_by_customer_id(2)

    assert_instance_of Array, actual
    assert_instance_of Invoice, actual.sample
    assert_equal 4, actual.length
  end

  def test_it_can_find_all_invoices_by_merchant_id
    actual = invoice_repo.find_all_by_merchant_id(12336965)

    assert_instance_of Array, actual
    assert_instance_of Invoice, actual.sample
    assert_equal 1, actual.length
  end

  def test_it_can_find_all_invoices_by_status
    actual = invoice_repo.find_all_by_status(:pending)

    assert_instance_of Array, actual
    assert_instance_of Invoice, actual.sample
    assert_equal 59, actual.length
  end

  def test_it_knows_about_parent_sales_engine
    assert_instance_of SalesEngine, invoice_repo.engine
  end

  def test_it_can_get_merchant_by_invoice
    actual = invoice_repo.merchant_by_invoice(12334112)

    assert_instance_of Merchant, actual
    assert_equal 12334112, actual.id
  end

  def test_it_can_get_items_by_invoice_id
    actual = invoice_repo.get_matching_items(3)

    assert_instance_of Array, actual
    assert_instance_of Item, actual.sample
    assert_equal 1, actual.count
  end

  def test_it_can_get_transactions_by_invoice_id
    actual = invoice_repo.get_transactions_by_invoice_id(46)

    assert_instance_of Array, actual
    assert_instance_of Transaction, actual.sample
    assert_equal 1, actual.count
  end

  def test_it_can_get_customer_by_invoice
    actual = invoice_repo.customer_by_invoice(21)

    assert_instance_of Customer, actual
    assert_equal 21, actual.id
  end

  def test_it_can_get_merchant_ids_by_customer_id
    actual = invoice_repo.merchant_ids_by_customer_id(3)

    assert_instance_of Array, actual
    assert_equal 3, actual.length
  end

  def test_it_can_get_customer_ids_by_merchant_id
    actual = invoice_repo.customer_ids_by_merchant_id(12337139)

    assert_instance_of Array, actual
    assert_equal 1, actual.length
  end

  def test_it_can_get_invoice_items_by_invoice
    actual = invoice_repo.get_invoice_items_by_invoice(1)

    assert_instance_of Array, actual
    assert_instance_of InvoiceItem, actual.sample
    assert_equal 8, actual.count
  end

  def test_it_can_find_all_by_date
    date = Time.parse("2009-02-07")
    actual = invoice_repo.find_all_by_date(date)

    assert_instance_of Invoice, actual.sample
    assert_equal 1, actual.count
  end
end
