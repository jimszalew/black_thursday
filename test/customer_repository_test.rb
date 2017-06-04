require 'minitest/autorun'
require 'minitest/pride'
require 'csv'
require_relative '../lib/customer_repository'

class CustomerRepositoryTest < Minitest::Test
  attr_reader :customer_repo
  def setup
    engine = Object.new
    csv = CSV.open './test/data/medium_customer_set.csv', headers: true, header_converters: :symbol
    @customer_repo = CustomerRepository.new(csv, engine)
  end

  def test_it_exists_and_populates_customers_automatically
    assert_instance_of CustomerRepository, customer_repo
    assert_instance_of Customer, customer_repo.customers[customer_repo.customers.keys.sample]
    assert_equal 120, customer_repo.customers.keys.length
  end

  def test_it_can_add_customers
    csv = CSV.open './test/data/medium_customer_set.csv', headers: true, header_converters: :symbol

    customer_repo.customers.clear

    customer_repo.add(csv)
    random_customer_key = customer_repo.customers.keys.sample

    assert_instance_of Customer, customer_repo.customers[random_customer_key]
  end


end
