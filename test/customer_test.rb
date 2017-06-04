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
end
