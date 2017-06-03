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
end
