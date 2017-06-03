require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/invoice'
# require_relative '../lib/invoice_repository'
# require_relative '../lib/sales_engine'
class InvoiceTest < Minitest::Test
  attr_reader :invoice
  def setup
    repository = Object.new
    @invoice = Invoice.new({
                            :id => "17",
                            :customer_id => "5",
                            :merchant_id => "12334912",
                            :status => "pending",
                            :created_at => "2005-06-03",
                            :updated_at => "2015-07-01"
                          }, repository)
  end

  def test_it_exists
    assert_instance_of Invoice, invoice
  end

  def test_it_has_an_id
    assert_equal 17, invoice.id
  end

  def test_it_knows_its_customer_id
    assert_equal 5, invoice.customer_id
  end

  def test_it_knows_its_merchant_id
    assert_equal 12334912, invoice.merchant_id
  end

  def test_it_has_a_status
    assert_equal "pending", invoice.status
  end

  def test_it_knows_when_it_was_created_and_updated
    assert_instance_of Time, invoice.created_at
    assert_instance_of Time, invoice.updated_at
  end

  def test_it_knows_about_parent_repo
    skip
    assert_instance_of InvoiceRepository, invoice.repository
  end
end
