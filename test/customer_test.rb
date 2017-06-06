require "minitest/autorun"
require "minitest/pride"
require_relative "../lib/customer"
require_relative "../lib/sales_engine"

class CustomerTest < Minitest::Test

  attr_reader :customer

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
    repository = engine.customers

    @customer = Customer.new({
                              :id => "5",
                              :first_name => "Joan",
                              :last_name => "Clarke",
                              :created_at => "2012-03-27 14:54:10 UTC",
                              :updated_at => "2012-03-27 14:54:10 UTC"
                            }, repository)
  end

  def test_it_exists
    assert_instance_of Customer, customer
  end

  def test_it_knows_its_id
    assert_equal 5, customer.id
  end

  def test_it_knows_its_first_name
    assert_equal "Joan", customer.first_name
  end

  def test_it_knows_its_last_name
    assert_equal "Clarke", customer.last_name
  end

  def test_it_knows_when_it_was_created_and_updated
    assert_instance_of Time, customer.created_at
    assert_instance_of Time, customer.updated_at
  end

  def test_it_knows_about_parent_repo
    assert_instance_of CustomerRepository, customer.repository
  end

  def test_it_can_get_its_merchants
    actual = customer.merchants

    assert_instance_of Array, actual
    assert_instance_of Merchant, actual.sample
    assert_equal 3, actual.length
  end
end
