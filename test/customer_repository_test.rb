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

  def test_it_exists
    assert_instance_of CustomerRepository, customer_repo
  end
end
