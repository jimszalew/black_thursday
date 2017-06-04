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
end
