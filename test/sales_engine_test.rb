require "minitest/autorun"
require "minitest/pride"
require_relative "../lib/sales_engine"
require "pry"

class SalesEngineTest < Minitest::Test
  attr_reader :se
  def setup
    csv_paths = {
                        :items     => "./test/data/medium_item_set.csv",
                        :merchants => "./test/data/medium_merchant_set.csv",
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
    assert_equal 200, se.items.all.length
    assert_instance_of Item, se.items.all.sample
  end

  def test_sales_engine_merchants_returns_all_merchant_instances
    assert_equal 200, se.merchants.all.length
    assert_instance_of Merchant, se.merchants.all.sample
  end

  def test_sales_engine_invoices_returns_all_invoice_instances
    assert_equal 200, se.invoices.all.length
    assert_instance_of Invoice, se.invoices.all.sample
  end

  def test_sales_engine_invoice_items_returns_all_invoice_item_instances
    assert_equal 200, se.invoice_items.all.length
    assert_instance_of InvoiceItem, se.invoice_items.all.sample
  end

  def test_sales_engine_transactions_returns_all_transactions_instances
    assert_equal 200, se.transactions.all.length
    assert_instance_of Transaction, se.transactions.all.sample
  end

  def test_sales_engine_customers_returns_all_customer_instances
    assert_equal 200, se.customers.all.length
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
    assert_equal 3, actual.count
    assert_equal 12335955, actual.sample.merchant_id
  end

  def test_it_can_get_merchant_by_invoice
    actual = se.merchant_by_invoice(12334112)

    assert_instance_of Merchant, actual
    assert_equal 12334112, actual.id
  end

  def test_it_can_get_number_of_invoices_by_weekday
    expected = {"Saturday"=>30, "Friday"=>35, "Wednesday"=>20, "Monday"=>26,
                "Sunday"=>33, "Tuesday"=>33, "Thursday"=>23}

    actual = se.invoices_by_weekday

    assert_equal expected, actual
  end

  def test_it_can_find_number_of_invoices_by_status
    expected = {pending: 59, shipped: 119, returned: 22}

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

  def test_it_can_get_transactions_by_invoice_id
    actual = se.get_transactions_by_invoice_id(46)

    assert_instance_of Array, actual
    assert_instance_of Transaction, actual.sample
    assert_equal 1, actual.count
  end

  def test_it_can_get_customer_by_invoice
    actual = se.customer_by_invoice(21)

    assert_instance_of Customer, actual
    assert_equal 21, actual.id
  end

  def test_it_can_get_invoice_by_transaction
    actual = se.invoice_by_transaction(18)

    assert_instance_of Invoice, actual
    assert_equal 18, actual.id
  end

  def test_it_can_get_merchant_ids_by_customer_id
    actual = se.merchant_ids_by_customer_id(3)

    assert_instance_of Array, actual
    assert_equal 3, actual.length
  end

  def test_it_can_get_merchants_by_customer_id
    actual = se.get_merchants_by_customer_id(5)

    assert_instance_of Array, actual
    assert_instance_of Merchant, actual.sample
    assert_equal 3, actual.count
  end

  def test_it_can_get_customer_ids_by_merchant_id
    actual = se.customer_ids_by_merchant_id(12337139)

    assert_instance_of Array, actual
    assert_equal 1, actual.length
  end

  def test_it_can_get_customers_by_merchant_id
    actual = se.get_customers_by_merchant_id(12337139)

    assert_instance_of Array, actual
    assert_instance_of Customer, actual.sample
    assert_equal 1, actual.count
  end

  def test_it_can_get_invoice_items_by_invoice
    actual = se.get_invoice_items_by_invoice(1)

    assert_instance_of Array, actual
    assert_instance_of InvoiceItem, actual.sample
    assert_equal 8, actual.count
  end

  def test_it_can_get_total_revenue_by_date_from_invoice_items
    actual = se.get_total_revenue_by_date
    random_day_key = actual.keys.sample

    assert_instance_of Hash, actual
    assert_instance_of Time, random_day_key
    assert_equal 590019.60, actual[actual.keys.first]
  end

  def test_it_can_get_merchannts_with_pending_invoices
    actual = se.get_merchants_with_pending_invoices

    assert actual.sample.pending_invoice?
  end
end
