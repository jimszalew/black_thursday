require 'minitest/autorun'
require 'minitest/pride'
require 'csv'
require_relative '../lib/invoice_item_repository'
# require_relative '../lib/sales_engine'

class InvoiceItemRepositoryTest < Minitest::Test

  attr_reader :invoice_item_repo

  def setup
    small_csv_paths = {
                        :invoice_items => './test/data/medium_invoice_item_set.csv',
                        :items     => "./test/data/small_item_set.csv",
                        :merchants => "./test/data/merchant_sample.csv",
                        :invoices => "./test/data/medium_invoice_set.csv"
                      }
    engine = Object.new
    # engine = SalesEngine.from_csv(small_csv_paths)
    csv = CSV.open './test/data/medium_invoice_item_set.csv', headers: true, header_converters: :symbol
    @invoice_item_repo = InvoiceItemRepository.new(csv, engine)
  end

  def test_it_exists_and_populates_invoices_items_automatically
    assert_instance_of InvoiceItemRepository, invoice_item_repo
    assert_instance_of InvoiceItem,  invoice_item_repo.invoice_items[invoice_item_repo.invoice_items.keys.sample]
    assert_equal 120, invoice_item_repo.invoice_items.keys.length
  end

  def test_it_can_add_invoice_itemss
    csv = CSV.open './test/data/medium_invoice_item_set.csv', headers: true, header_converters: :symbol

    invoice_item_repo.invoice_items.clear

    invoice_item_repo.add(csv)
    random_invoice_item_key = invoice_item_repo.invoice_items.keys.sample

    assert_instance_of InvoiceItem, invoice_item_repo.invoice_items[random_invoice_item_key]
  end

  def test_it_can_return_all_invoice_item_instances
    actual = invoice_item_repo.all
    assert_equal 120, actual.length
    assert_instance_of InvoiceItem, actual.sample
  end
end
