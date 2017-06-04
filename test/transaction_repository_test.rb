require 'minitest/autorun'
require 'minitest/pride'
require 'csv'
require_relative '../lib/transaction_repository'
# require_relative "../lib/sales_engine"

class TransactionRepositoryTest < Minitest::Test
  attr_reader :transaction_repo
  def setup
    engine = Object.new
    csv = CSV.open './test/data/medium_invoice_set.csv', headers: true, header_converters: :symbol
    @transaction_repo = TransactionRepository.new(csv, engine)
  end

  def test_it_exists_and_populates_transactions_automatically
    assert_instance_of TransactionRepository, transaction_repo
    assert_instance_of Transaction, transaction_repo.transactions[transaction_repo.transactions.keys.sample]
    assert_equal 120, transaction_repo.transactions.keys.length
  end
end
