require "minitest/autorun"
require "minitest/pride"
require_relative "../lib/customer"

class CustomerTest < Minitest::Test

  attr_reader :customer

  def setup
    repository = Object.new
    @customer = Customer.new({
                              :id => "6",
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
    assert_equal 6, customer.id
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
end
