require 'minitest/autorun'
require 'minitest/pride'
require './lib/merchant_repository'
require_relative '../lib/sales_engine'

class MerchantRepositoryTest < Minitest::Test

  attr_reader :merch_repo

  def setup
    csv_paths = {
                        :items     => "./test/data/medium_item_set.csv",
                        :merchants => "./test/data/medium_merchant_set.csv",
                        :invoices => "./test/data/medium_invoice_set.csv",
                        :invoice_items => "./test/data/medium_invoice_item_set.csv",
                        :transactions => "./test/data/medium_transaction_set.csv",
                        :customers => "./test/data/medium_customer_set.csv"
                      }

    engine = SalesEngine.from_csv(csv_paths)

    @merch_repo = engine.merchants
  end

  def test_merchant_repository_exists
    assert_instance_of MerchantRepository, merch_repo
  end

  def test_it_can_add_merchants
    csv = CSV.open('./test/data/merchant_sample.csv', headers: true, header_converters: :symbol)

    merch_repo.merchants.clear

    merch_repo.add(csv)
    random_merch_key = merch_repo.merchants.keys.sample

    assert_instance_of Merchant, merch_repo.merchants[random_merch_key]
  end

  def test_it_can_return_all_merchants
    actual = merch_repo.all
    assert_equal 200, actual.length
    assert_instance_of Merchant, actual.sample
  end

  def test_it_can_find_merchants_by_id
    assert_instance_of Merchant, merch_repo.find_by_id("12334105")
  end

  def test_it_returns_nil_for_invalid_id
    assert_nil merch_repo.find_by_id("42")
  end

  def test_it_can_find_merchants_by_name
    assert_instance_of Merchant, merch_repo.find_by_name("Candisart")
  end

  def test_it_returns_nil_for_invalid_name
    assert_nil merch_repo.find_by_name("Stuff")
  end

  def test_it_can_find_all_merchants_containing_given_name_fragment
    merchant_ids = [12334113, 12334123, 12334305,
                    12334365, 12334444, 12334670,
                    12334671, 12334780, 12334788,
                    12334815, 12334984]
    merchants = merch_repo.get_matching_merchants(merchant_ids)

    assert_equal [], merch_repo.find_all_by_name("jjj")
    assert_equal merchants, merch_repo.find_all_by_name("ke")
  end

  def test_it_knows_about_parent_sales_engine
    assert_instance_of SalesEngine, merch_repo.engine
  end

  def test_it_can_get_merchant_items_from_parent_sales_engine
    actual = merch_repo.all_merchant_items(12334213)

    assert_instance_of Array, actual
    assert_instance_of Item, actual.sample
    assert_equal 2, actual.count
    assert_equal 12334213, actual.sample.merchant_id
  end

  def test_it_can_return_all_invoices_from_parent_sales_engine
    actual = merch_repo.all_merchant_invoices(12335955)

    assert_instance_of Array, actual
    assert_instance_of Invoice, actual.sample
    assert_equal 3, actual.count
    assert_equal 12335955, actual.sample.merchant_id
  end

  def test_it_can_get_matching_merchants
    actual = merch_repo.get_matching_merchants([12334141, 12334160])

    assert_instance_of Array, actual
    assert_instance_of Merchant, actual.sample
    assert_equal 2, actual.count
  end

  def test_it_can_get_customers_by_merchant_id
    actual = merch_repo.get_customers_by_merchant_id(12337139)

    assert_instance_of Array, actual
    assert_instance_of Customer, actual.sample
    assert_equal 1, actual.count
  end

  def test_it_can_sort_merchants_by_total_revenue
    actual = merch_repo.merchants_by_total_revenue

    assert_instance_of Array, actual
    assert_instance_of Merchant, actual.sample
    assert (actual[0].total_revenue > actual[1].total_revenue)
  end

  def test_it_can_find_merchants_with_pending_invoices
    actual = merch_repo.merchants_with_pending_invoices

    assert actual.sample.pending_invoice?
  end
end
