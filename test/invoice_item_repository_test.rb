require 'minitest/autorun'
require 'minitest/pride'
require 'csv'
require_relative '../lib/invoice_item_repository'
require_relative '../lib/sales_engine'
require 'pry'
class InvoiceItemRepositoryTest < Minitest::Test

  attr_reader :invoice_item_repo

  def setup
    csv_paths = {
                        :items     => "./test/data/medium_item_set.csv",
                        :merchants => "./test/data/medium_merchant_set.csv",
                        :invoices => "./test/data/medium_invoice_set.csv",
                        :invoice_items => "./test/data/medium_invoice_item_set.csv",
                        :transactions => "./test/data/medium_transaction_set.csv",
                        :customers => "./test/data/medium_customer_set.csv"
                      }

    engine = SalesEngine.from_csv(csv_paths)

    @invoice_item_repo = engine.invoice_items
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

  def test_it_can_find_invoice_item_by_id
    id = 13

    assert_instance_of InvoiceItem, invoice_item_repo.find_by_id(id)
    assert_equal id, invoice_item_repo.find_by_id(id).id
  end

  def test_returns_nil_for_invalid_id
    id = "2412341234"

    assert_nil invoice_item_repo.find_by_id(id)
  end

  def test_it_can_find_all_invoice_items_by_item_id
    actual = invoice_item_repo.find_all_by_item_id(263526970)

    assert_instance_of Array, actual
    assert_instance_of InvoiceItem, actual.sample
    assert_equal 1, actual.length
  end

  def test_it_can_find_all_invoice_items_by_invoice_id
    actual = invoice_item_repo.find_all_by_invoice_id(3)

    assert_instance_of Array, actual
    assert_instance_of InvoiceItem, actual.sample
    assert_equal 8, actual.length
  end

  def test_it_can_calculate_total_revenue_by_date
    actual = invoice_item_repo.total_revenue_by_date
    random_day_key = actual.keys.sample
    
    assert_instance_of Hash, actual
    assert_instance_of Time, random_day_key
    assert_equal 33402.68, actual[actual.keys.first]
  end
end
