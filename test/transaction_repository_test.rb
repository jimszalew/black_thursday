require 'minitest/autorun'
require 'minitest/pride'
require 'csv'
require_relative '../lib/transaction_repository'
require_relative '../lib/invoice'
require_relative "../lib/sales_engine"

class TransactionRepositoryTest < Minitest::Test
  attr_reader :transaction_repo
  def setup
    csv_paths = {
                        :items     => "./test/data/small_item_set.csv",
                        :merchants => "./test/data/merchant_sample.csv",
                        :invoices => "./test/data/medium_invoice_set.csv",
                        :invoice_items => "./test/data/medium_invoice_item_set.csv",
                        :transactions => "./test/data/medium_transaction_set.csv",
                        :customers => "./test/data/medium_customer_set.csv"
                      }

    engine = SalesEngine.from_csv(csv_paths)

    @transaction_repo = engine.transactions
  end

  def test_it_exists_and_populates_transactions_automatically
    assert_instance_of TransactionRepository, transaction_repo
    assert_instance_of Transaction, transaction_repo.transactions[transaction_repo.transactions.keys.sample]
    assert_equal 200, transaction_repo.transactions.keys.length
  end

  def test_it_can_add_transactions
    csv = CSV.open './test/data/medium_transaction_set.csv', headers: true, header_converters: :symbol

    transaction_repo.transactions.clear

    transaction_repo.add(csv)
    random_transaction_key = transaction_repo.transactions.keys.sample

    assert_instance_of Transaction, transaction_repo.transactions[random_transaction_key]
  end

  def test_it_can_return_all_transaction_instances
    actual = transaction_repo.all
    assert_equal 200, actual.length
    assert_instance_of Transaction, actual.sample
  end

  def test_it_can_find_transaction_by_id
    id = 6

    assert_instance_of Transaction, transaction_repo.find_by_id(id)
    assert_equal id, transaction_repo.find_by_id(id).id
  end

  def test_returns_nil_for_invalid_id
    assert_nil transaction_repo.find_by_id(678593)
  end

  def test_it_can_find_all_transactions_by_invoice_id
    actual = transaction_repo.find_all_by_invoice_id(31)

    assert_instance_of Array, actual
    assert_instance_of Transaction, actual.sample
    assert_equal 1, actual.length
    assert transaction_repo.find_all_by_invoice_id(1).empty?
  end

  def test_it_can_find_all_transactions_by_cc_num
    actual = transaction_repo.find_all_by_credit_card_number(4613250127567219)

    assert_instance_of Array, actual
    assert_instance_of Transaction, actual.sample
    assert_equal 1, actual.length
    assert transaction_repo.find_all_by_credit_card_number("123124132534242").empty?
  end

  def test_it_can_find_all_transactions_by_result
    actual = transaction_repo.find_all_by_result("success")

    assert_instance_of Array, actual
    assert_instance_of Transaction, actual.sample
    assert_equal 162, actual.length
    assert transaction_repo.find_all_by_result("successful").empty?
  end

  def test_it_knows_about_parent_sales_engine
    assert_instance_of SalesEngine, transaction_repo.engine
  end

  def test_it_can_get_invoice_by_transaction
    actual = transaction_repo.invoice_by_transaction(18)

    assert_instance_of Invoice, actual
    assert_equal 18, actual.id
  end
end
