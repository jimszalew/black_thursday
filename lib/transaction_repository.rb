require_relative 'transaction'

class TransactionRepository
  attr_reader :transactions

  def initialize(csv, engine)
    @transactions = {}
    @engine = engine
    self.add(csv)
  end

  def add(csv)
    csv.each do |row|
      row_data = row.to_h
      transactions[row_data[:id].to_i] = Transaction.new(row_data, self)
    end
  end

  def all
    transactions.values
  end

  def find_by_id(id)
    transactions[id]
  end

  def find_all_by_invoice_id(invoice_id)
    all.find_all do |transaction|
      transaction.invoice_id == invoice_id
    end
  end

  def find_all_by_credit_card_number(cc_number)
    all.find_all do |transaction|
      transaction.credit_card_number == cc_number
    end
  end
end
