require 'minitest/autorun'
require 'minitest/pride'
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
                        :invoices => "./test/data/medium_invoice_set.csv"
                      }
    engine  = SalesEngine.from_csv(csv_paths)
    @analyst = SalesAnalyst.new(engine)

    medium_csv_paths = {
                        :items     => "./test/data/medium_item_set.csv",
                        :merchants => "./test/data/medium_merchant_set.csv",
                        :invoices => "./test/data/medium_invoice_set.csv"
                      }
    engine_2  = SalesEngine.from_csv(medium_csv_paths)
    @analyst_2 = SalesAnalyst.new(engine_2)
  end

  def test_sales_analyst_exists_and_knows_about_sales_engine
    assert_instance_of SalesAnalyst, analyst
    assert_instance_of SalesEngine, analyst.engine
  end

  def test_it_can_find_average_items_per_merchant
    assert_equal 1.2, analyst.average_items_per_merchant
    assert_equal 1.45, analyst_2.average_items_per_merchant
  end

  def test_it_can_calculate_standard_deviation_for_average_items_per_merchant
    assert_equal 1.39, analyst_2.average_items_per_merchant_standard_deviation
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
    assert_equal 6.66, actual
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
    assert_equal 183.20, actual
  end

  def test_it_knows_standard_deviation_of_average_average_item_price
    assert_equal 236.68, analyst_2.average_item_price_standard_deviation
  end

  def test_it_can_find_average_invoices_per_merchant
    assert_equal 4.0, analyst.average_invoices_per_merchant
    assert_equal 1.0, analyst_2.average_invoices_per_merchant
  end

  def test_it_can_calculate_standard_deviation_for_average_invoice_per_merchant
    assert_equal 1.0, analyst_2.average_invoices_per_merchant_standard_deviation
  end

  def test_it_knows_merchants_with_high_invoice_count
    csv_paths = {
                        :items     => "./data/items.csv",
                        :merchants => "./data/merchants.csv",
                        :invoices => "./data/invoices.csv"
                      }
    engine = SalesEngine.from_csv(csv_paths)
    analyst_2 = SalesAnalyst.new(engine)

    actual = analyst_2.top_merchants_by_invoice_count

    assert_instance_of Array, actual
    assert_instance_of Merchant, actual.sample
  end

  def test_it_knows_merchants_with_low_invoice_count
    csv_paths = {
                        :items     => "./data/items.csv",
                        :merchants => "./data/merchants.csv",
                        :invoices => "./data/invoices.csv"
                      }
    engine = SalesEngine.from_csv(csv_paths)
    analyst_2 = SalesAnalyst.new(engine)

    actual = analyst_2.bottom_merchants_by_invoice_count

    assert_instance_of Array, actual
    assert_instance_of Merchant, actual.sample
  end

  def test_it_can_calculate_average_invoices_per_day
    assert_equal 2.86, analyst_2.average_invoices_per_day
  end

  def test_it_can_find_standard_deviation_of_invoices_created_per_day
    assert_equal 2.12, analyst_2.invoices_per_day_standard_deviation
  end

  def test_it_can_find_top_days_by_invoice_count
    actual = analyst_2.top_days_by_invoice_count

    assert_instance_of Array, actual
    assert_instance_of String, actual.sample
    assert_equal 2, actual.count
  end
end
