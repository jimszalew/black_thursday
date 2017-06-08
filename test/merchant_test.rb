require_relative 'test_helper'
require_relative '../lib/merchant'
require_relative '../lib/merchant_repository'
require_relative '../lib/sales_engine'


class MerchantTest < Minitest::Test

  attr_reader :merchant,
              :merchant2,
              :merchant3,
              :merchant4

  def setup
    csv_paths = {
                        :items     => "./test/data/small_item_set.csv",
                        :merchants => "./test/data/medium_merchant_set.csv",
                        :invoices => "./test/data/medium_invoice_set.csv",
                        :invoice_items => "./test/data/medium_invoice_item_set.csv",
                        :transactions => "./test/data/medium_transaction_set.csv",
                        :customers => "./test/data/medium_customer_set.csv"
                      }

    engine = SalesEngine.from_csv(csv_paths)
    repo = engine.merchants
    @merchant = Merchant.new({:id => 12337139, :name => "StarCityGames", :created_at => "2012-03-27"}, repo)
    @merchant2 = Merchant.new({:id => 12335955, :name => "Amazong", :created_at => "2012-03-27"},repo)
    @merchant3 = Merchant.new({:id => 12334213, :name => "Sal's Sassafras Supply", :created_at => "2012-03-27"},repo)
    @merchant4 = Merchant.new({:id => 12334123, :name => "Stuff.io", :created_at => "2012-03-27"},repo)
  end

  def test_it_exists
    assert_instance_of Merchant, merchant
    assert_instance_of Merchant, merchant2
  end

  def test_it_has_id
    assert_equal 12337139, merchant.id
  end

  def test_it_has_a_name
    assert_equal "StarCityGames", merchant.name
  end

  def test_it_knows_when_it_was_created
    assert_instance_of Time, merchant.created_at
  end

  def test_it_can_have_different_id
    assert_equal 12335955, merchant2.id
  end

  def test_it_can_have_different_name
    assert_equal "Amazong", merchant2.name
  end

  def test_it_knows_about_parent_repo
    assert_instance_of MerchantRepository, merchant.repository
    assert_instance_of MerchantRepository, merchant2.repository
  end

  def test_it_can_get_all_its_items
    actual = merchant3.items

    assert_instance_of Array, actual
    assert_instance_of Item, actual.sample
    assert_equal 2, actual.count
    assert_equal 12334213, actual.sample.merchant_id
  end

  def test_it_can_get_all_its_invoices
    actual = merchant2.invoices

    assert_instance_of Array, actual
    assert_instance_of Invoice, actual.sample
    assert_equal 3, actual.count
    assert_equal 12335955, actual.sample.merchant_id
  end

  def test_it_can_get_its_customers
    actual = merchant.customers

    assert_instance_of Array, actual
    assert_instance_of Customer, actual.sample
    assert_equal 1, actual.length
  end

  def test_it_can_get_its_total_revenue
    actual = merchant.total_revenue

    assert_equal 24776.52, actual
  end

  def test_it_knows_if_invoices_pending
    assert merchant2.pending_invoice?
  end

  def test_it_can_get_all_invoice_items
    actual = merchant.invoice_items

    assert_instance_of Array, actual
    assert_instance_of InvoiceItem, actual.sample
  end

  def test_it_can_find_paid_invoices
    actual = merchant4.paid_invoices

    assert_instance_of Array, actual
    assert_instance_of Invoice, actual.sample
    assert actual.sample.is_paid_in_full?
  end
end
