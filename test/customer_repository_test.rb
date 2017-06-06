require 'minitest/autorun'
require 'minitest/pride'
require 'csv'
require_relative '../lib/customer_repository'
require_relative '../lib/sales_engine'

class CustomerRepositoryTest < Minitest::Test
  attr_reader :customer_repo
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

    @customer_repo = engine.customers
  end

  def test_it_exists_and_populates_customers_automatically
    assert_instance_of CustomerRepository, customer_repo
    assert_instance_of Customer, customer_repo.customers[customer_repo.customers.keys.sample]
    assert_equal 200, customer_repo.customers.keys.length
  end

  def test_it_can_add_customers
    csv = CSV.open './test/data/medium_customer_set.csv', headers: true, header_converters: :symbol

    customer_repo.customers.clear

    customer_repo.add(csv)
    random_customer_key = customer_repo.customers.keys.sample

    assert_instance_of Customer, customer_repo.customers[random_customer_key]
  end

  def test_it_can_return_all_customer_instances
    actual = customer_repo.all
    assert_equal 200, actual.length
    assert_instance_of Customer, actual.sample
  end

  def test_it_can_find_customer_by_id
    id = 6

    assert_instance_of Customer, customer_repo.find_by_id(id)
    assert_equal id, customer_repo.find_by_id(id).id
  end

  def test_returns_nil_for_invalid_id
    assert_nil customer_repo.find_by_id(678593)
  end

  def test_it_can_find_all_customers_by_first_name
    actual = customer_repo.find_all_by_first_name("Kailee")

    assert_instance_of Array, actual
    assert_instance_of Customer, actual.sample
    assert_equal 1, actual.length
    assert customer_repo.find_all_by_first_name("C'thulu").empty?
  end

  def test_it_can_find_all_customers_by_last_name
    actual = customer_repo.find_all_by_last_name("McCullough")

    assert_instance_of Array, actual
    assert_instance_of Customer, actual.sample
    assert_equal 2, actual.length
    assert customer_repo.find_all_by_last_name("C'thulu").empty?
  end

  def test_it_knows_about_parent_sales_engine
    assert_instance_of SalesEngine, customer_repo.engine
  end

  def test_it_can_get_merchants_by_customer_id
    actual = customer_repo.get_merchants_by_customer_id(5)

    assert_instance_of Array, actual
    assert_instance_of Merchant, actual.sample
    assert_equal 3, actual.count
  end

  def test_it_can_get_matching_customers
    actual = customer_repo.get_matching_customers([9, 12])

    assert_instance_of Array, actual
    assert_instance_of Customer, actual.sample
    assert_equal 2, actual.count
  end
end
