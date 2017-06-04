require "minitest/autorun"
require "minitest/pride"
require_relative "../lib/transaction"
require_relative "../lib/sales_engine"

class TransactionTest < Minitest::Test
  attr_reader :transaction
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
    repository = engine.transactions

    @transaction = Transaction.new({
                          :id => "6",
                          :invoice_id => "18",
                          :credit_card_number => "4558368405929183",
                          :credit_card_expiration_date => "0417",
                          :result => "success",
                          :created_at => "2012-02-26 20:56:57 UTC",
                          :updated_at => "2012-02-26 20:56:57 UTC"
                        }, repository)
  end

  def test_it_exists
    assert_instance_of Transaction, transaction
  end

  def test_it_knows_its_id
    assert_equal 6, transaction.id
  end

  def test_it_knows_its_invoice_id
    assert_equal 18, transaction.invoice_id
  end

  def test_it_knows_its_credit_card_number
    assert_equal "4558368405929183", transaction.credit_card_number
  end

  def test_it_knows_its_credit_card_expiration_date
    assert_equal "0417", transaction.credit_card_expiration_date
  end

  def test_it_knows_result_of_transaction
    assert_equal 'success', transaction.result
  end

  def test_it_knows_when_it_was_created_and_updated
    assert_instance_of Time, transaction.created_at
    assert_instance_of Time, transaction.updated_at
  end

  def test_it_knows_about_parent_repo
    assert_instance_of TransactionRepository, transaction.repository
  end

  def test_it_can_get_its_invoice
    actual = transaction.invoice

    assert_instance_of Invoice, actual
    assert_equal 18, actual.id
  end
end
