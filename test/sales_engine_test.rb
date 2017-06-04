require "minitest/autorun"
require "minitest/pride"
require_relative "../lib/sales_engine"
require "pry"

class SalesEngineTest < Minitest::Test
  attr_reader :se
  def setup
    csv_paths = {
                        :items     => "./test/data/medium_item_set.csv",
                        :merchants => "./test/data/merchant_sample.csv",
                        :invoices => "./test/data/medium_invoice_set.csv",
                        :invoice_items => "./test/data/medium_invoice_item_set.csv",
                        :transactions => "./test/data/medium_transaction_set.csv",
                        :customers => "./test/data/medium_customer_set.csv"
                      }

    @se = SalesEngine.from_csv(csv_paths)
  end

  def test_it_exists
    assert_instance_of SalesEngine, se
  end

  def test_from_csv_returns_instance_of_sales_engine
    assert_instance_of SalesEngine, se
  end

  def test_sales_engine_items_returns_item_repo_instance
    assert_instance_of ItemRepository, se.items
  end

  def test_sales_engine_merchants_returns_merchant_repo_instance
    assert_instance_of MerchantRepository, se.merchants
  end

  def test_sales_engine_invoices_returns_invoice_repo_instance
    assert_instance_of InvoiceRepository, se.invoices
  end

  def test_sales_engine_invoice_items_returns_invoice_item_repo_instance
    assert_instance_of InvoiceItemRepository, se.invoice_items
  end

  def test_sales_engine_transactions_returns_transaction_repo_instance
    assert_instance_of TransactionRepository, se.transactions
  end

  def test_sales_engine_customers_returns_customer_repo_instance
    assert_instance_of CustomerRepository, se.customers
  end

  def test_sales_engine_items_returns_all_item_instances
    assert_equal 29, se.items.all.length
    assert_instance_of Item, se.items.all.sample
  end

  def test_sales_engine_merchants_returns_all_merchant_instances
    assert_equal 5, se.merchants.all.length
    assert_instance_of Merchant, se.merchants.all.sample
  end

  def test_sales_engine_invoices_returns_all_invoice_instances
    assert_equal 20, se.invoices.all.length
    assert_instance_of Invoice, se.invoices.all.sample
  end

  def test_sales_engine_invoice_items_returns_all_invoice_item_instances
    assert_equal 120, se.invoice_items.all.length
    assert_instance_of InvoiceItem, se.invoice_items.all.sample
  end

  def test_sales_engine_transactions_returns_all_transactions_instances
    assert_equal 120, se.transactions.all.length
    assert_instance_of Transaction, se.transactions.all.sample
  end

  def test_sales_engine_customers_returns_all_customer_instances
    assert_equal 120, se.customers.all.length
    assert_instance_of Customer, se.customers.all.sample
  end

  def test_it_can_return_all_items_for_a_merchant
    actual = se.all_merchant_items(12334213)

    assert_instance_of Array, actual
    assert_instance_of Item, actual.sample
    assert_equal 2, actual.count
    assert_equal 12334213, actual.sample.merchant_id
  end

  def test_it_can_get_merchant_by_item
    actual = se.merchant_by_item(12334113)

    assert_instance_of Merchant, actual
    assert_equal 12334113, actual.id
  end

  def test_it_can_return_all_invoices_for_a_merchant
    actual = se.all_merchant_invoices(12335955)

    assert_instance_of Array, actual
    assert_instance_of Invoice, actual.sample
    assert_equal 2, actual.count
    assert_equal 12335955, actual.sample.merchant_id
  end

  def test_it_can_get_merchant_by_invoice
    actual = se.merchant_by_invoice(12334112)

    assert_instance_of Merchant, actual
    assert_equal 12334112, actual.id
  end

  def test_it_can_get_number_of_invoices_by_weekday
    expected = {"Saturday"=>5, "Friday"=>6, "Wednesday"=>1,
                "Monday"=>4, "Sunday"=>1, "Tuesday"=>2,
                "Thursday"=>1}

    actual = se.invoices_by_weekday

    assert_equal expected, actual
  end

  def test_it_can_find_number_of_invoices_by_status
    expected = {pending: 9, shipped: 10, returned: 1}

    actual = se.invoices_by_status

    assert_equal expected, actual
  end

  def test_it_can_find_item_ids_by_invoice_id
    actual = se.item_ids_by_invoice_id(3)
    assert_instance_of Array, actual
    assert_equal 8, actual.length
  end

  def test_it_can_get_items_by_invoice_id
    actual = se.get_items_by_invoice_id(3)

    assert_instance_of Array, actual
    assert_instance_of Item, actual.sample
    assert_equal 1, actual.count
  end
end
