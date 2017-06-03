require 'minitest/autorun'
require 'minitest/pride'
require 'csv'
require_relative '../lib/invoice_repository'

class InvoiceRepositoryTest < Minitest::Test
  attr_reader :invoice_repo
  def setup
    engine = Object.new
    csv = CSV.open './test/data/medium_invoice_set.csv', headers: true, header_converters: :symbol
    @invoice_repo = InvoiceRepository.new(csv, engine)
  end

  def test_it_exists_and_populates_invoices_automatically
    assert_instance_of InvoiceRepository, invoice_repo
    assert_instance_of Invoice, invoice_repo.invoices[invoice_repo.invoices.keys.sample]
    assert_equal 20, invoice_repo.invoices.keys.length
  end

  def test_it_can_add_invoices
    csv = CSV.open './test/data/medium_invoice_set.csv', headers: true, header_converters: :symbol

    invoice_repo.invoices.clear

    invoice_repo.add(csv)
    random_invoice_key = invoice_repo.invoices.keys.sample

    assert_instance_of Invoice, invoice_repo.invoices[random_invoice_key]
  end

  def test_it_can_return_all_invoice_instances
    actual = invoice_repo.all
    assert_equal 20, actual.length
    assert_instance_of Invoice, actual.sample
  end

  def test_it_can_find_invoice_by_id
    id = 13

    assert_instance_of Invoice, invoice_repo.find_by_id(id)
    assert_equal id, invoice_repo.find_by_id(id).id
  end

  def test_returns_nil_for_invalid_id
    id = "2412341234"

    assert_nil invoice_repo.find_by_id(id)
  end

  def test_it_can_find_all_items_by_customer_id
    actual = invoice_repo.find_all_by_customer_id(2)

    assert_instance_of Array, actual
    assert_instance_of Invoice, actual.sample
    assert_equal 4, actual.length
  end

  def test_it_can_find_all_items_by_merchant_id
    actual = invoice_repo.find_all_by_merchant_id(12336965)

    assert_instance_of Array, actual
    assert_instance_of Invoice, actual.sample
    assert_equal 1, actual.length
  end
end
