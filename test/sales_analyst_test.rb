require 'minitest/autorun'
require 'minitest/pride'
require 'time'
require_relative '../lib/sales_analyst'
require_relative '../lib/sales_engine'
require 'pry'

class SalesAnalystTest < Minitest::Test

  attr_reader :analyst,
              :analyst_2

  def setup
    # item_dummy = CSV.open './test/data/small_item_set.csv', headers: true, header_converters: :symbol
    # merch_dummy = CSV.open './test/data/merchant_sample.csv', headers: true, header_converters: :symbol
    csv_paths = {
                        :items     => "./test/data/small_item_set.csv",
                        :merchants => "./test/data/merchant_sample.csv",
                        :invoices => "./test/data/medium_invoice_set.csv",
                        :invoice_items => "./test/data/medium_invoice_item_set.csv",
                        :transactions => "./test/data/medium_transaction_set.csv",
                        :customers => "./test/data/medium_customer_set.csv"
                      }
    engine  = SalesEngine.from_csv(csv_paths)
    @analyst = SalesAnalyst.new(engine)

    csv_paths = {
                        :items     => "./test/data/medium_item_set.csv",
                        :merchants => "./test/data/medium_merchant_set.csv",
                        :invoices => "./test/data/medium_invoice_set.csv",
                        :invoice_items => "./test/data/medium_invoice_item_set.csv",
                        :transactions => "./test/data/medium_transaction_set.csv",
                        :customers => "./test/data/medium_customer_set.csv"
                      }

    engine_2 = SalesEngine.from_csv(csv_paths)
    @analyst_2 = SalesAnalyst.new(engine_2)
  end

  def test_sales_analyst_exists_and_knows_about_sales_engine
    assert_instance_of SalesAnalyst, analyst
    assert_instance_of SalesEngine, analyst.engine
  end

  def test_it_can_find_average_items_per_merchant
    assert_equal 1.2, analyst.average_items_per_merchant
    assert_equal 1.0, analyst_2.average_items_per_merchant
  end

  def test_it_can_calculate_standard_deviation_for_average_items_per_merchant
    assert_equal 1.91, analyst_2.average_items_per_merchant_standard_deviation
  end

  def test_it_knows_merchants_with_high_item_count
    actual = analyst_2.merchants_with_high_item_count

    assert_instance_of Array, actual
    assert_instance_of Merchant, actual.sample
  end

  def test_it_can_find_average_item_price_for_merchant
    actual = analyst_2.average_item_price_for_merchant(12334185)

    assert_instance_of BigDecimal, actual
    assert_equal 11.17, actual
  end

  def test_it_can_find_average_average_price_per_merchant
    actual = analyst_2.average_average_price_per_merchant

    assert_instance_of BigDecimal, actual
    assert_equal 565.18, actual.to_f
  end

  def test_it_can_find_golden_items
    actual = analyst_2.golden_items
    std_dev = analyst_2.average_item_price_standard_deviation

    assert_instance_of Array, actual
    assert_instance_of Item, actual.sample
    assert (actual.sample.unit_price - analyst_2.average_average_price_per_merchant) > (2 * std_dev)
  end

  def test_it_can_find_average_item_price
    actual = analyst_2.average_item_price

    assert_instance_of BigDecimal, actual
    assert_equal 648.18, actual.to_f
  end

  def test_it_knows_standard_deviation_of_average_average_item_price
    assert_equal 7069.43, analyst_2.average_item_price_standard_deviation
  end

  def test_it_can_find_average_invoices_per_merchant
    assert_equal 40.0, analyst.average_invoices_per_merchant
    assert_equal 1.0, analyst_2.average_invoices_per_merchant
  end

  def test_it_can_calculate_standard_deviation_for_average_invoice_per_merchant
    assert_equal 0.86, analyst_2.average_invoices_per_merchant_standard_deviation
  end

  def test_it_knows_merchants_with_high_invoice_count
    skip
    csv_paths = {
                        :items     => "./data/items.csv",
                        :merchants => "./data/merchants.csv",
                        :invoices => "./data/invoices.csv",
                        :invoice_items => "./data/invoice_items.csv",
                        :transactions => "./data/transactions.csv",
                        :customers => "./data/customers.csv"
                      }
    engine = SalesEngine.from_csv(csv_paths)
    analyst_2 = SalesAnalyst.new(engine)

    actual = analyst_2.top_merchants_by_invoice_count

    assert_instance_of Array, actual
    assert_instance_of Merchant, actual.sample
  end

  def test_it_knows_merchants_with_low_invoice_count
    skip
    csv_paths = {
                        :items     => "./data/items.csv",
                        :merchants => "./data/merchants.csv",
                        :invoices => "./data/invoices.csv",
                        :invoice_items => "./data/invoice_items.csv",
                        :transactions => "./data/transactions.csv",
                        :customers => "./data/customers.csv"
                      }
    engine = SalesEngine.from_csv(csv_paths)
    analyst_2 = SalesAnalyst.new(engine)

    actual = analyst_2.bottom_merchants_by_invoice_count

    assert_instance_of Array, actual
    assert_instance_of Merchant, actual.sample
  end

  def test_it_can_calculate_average_invoices_per_day
    assert_equal 28.57, analyst_2.average_invoices_per_day
  end

  def test_it_can_find_standard_deviation_of_invoices_created_per_day
    assert_equal 5.68, analyst_2.invoices_per_day_standard_deviation
  end

  def test_it_can_find_top_days_by_invoice_count
    actual = analyst_2.top_days_by_invoice_count

    assert_instance_of Array, actual
    assert_instance_of String, actual.sample
    assert_equal 1, actual.count
  end

  def test_it_knows_percentage_of_invoices_by_status
    assert_equal 11.0, analyst_2.invoice_status(:returned)
    assert_equal 29.5, analyst_2.invoice_status(:pending)
    assert_equal 59.5, analyst_2.invoice_status(:shipped)
  end

  def test_it_can_get_total_revenue_by_date
    date = Time.parse('2012-03-27')
    assert_equal 590019.60, analyst_2.total_revenue_by_date(date)
  end

  def test_it_can_find_top_revenue_earners
    actual = analyst_2.top_revenue_earners(25)
    other_actual = analyst_2.top_revenue_earners

    assert_instance_of Array, actual
    assert_instance_of Merchant, actual.sample
    assert_equal 25, actual.count
    assert_equal 20, other_actual.count
  end

  def test_it_can_get_merchannts_with_pending_invoices
    actual = analyst_2.merchants_with_pending_invoices

    assert actual.sample.pending_invoice?
  end

  def test_it_can_find_merchants_with_only_one_item
    actual = analyst_2.merchants_with_only_one_item
    assert_instance_of Array, actual
    assert_instance_of Merchant, actual.sample
    assert_equal 1, actual.sample.items.count
  end

  def test_it_can_find_merchants_with_only_one_item_registered_in_month
    actual = analyst_2.merchants_with_only_one_item_registered_in_month('December')
    assert_instance_of Array, actual
    assert_instance_of Merchant, actual.sample
    assert_equal 12, actual.sample.created_at.month
  end
end
