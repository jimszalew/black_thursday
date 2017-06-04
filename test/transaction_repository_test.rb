require 'minitest/autorun'
require 'minitest/pride'
require 'csv'
require_relative '../lib/transaction_repository'
# require_relative "../lib/sales_engine"

class TransactionRepositoryTest < Minitest::Test
  attr_reader :transaction_repo
  def setup
    engine = Object.new
    csv = CSV.open './test/data/medium_transaction_set.csv', headers: true, header_converters: :symbol
    @transaction_repo = TransactionRepository.new(csv, engine)
  end

  def test_it_exists_and_populates_transactions_automatically
    assert_instance_of TransactionRepository, transaction_repo
    assert_instance_of Transaction, transaction_repo.transactions[transaction_repo.transactions.keys.sample]
    assert_equal 120, transaction_repo.transactions.keys.length
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
    assert_equal 120, actual.length
    assert_instance_of Transaction, actual.sample
  end
end
