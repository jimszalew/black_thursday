require_relative 'transaction'

class TransactionRepository
  attr_reader :transactions

  def initialize(csv, engine)
    @transactions = {}
  end
end
