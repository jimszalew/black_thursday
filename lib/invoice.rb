require 'time'

class Invoice

  attr_reader :id,
              :customer_id,
              :merchant_id,
              :status,
              :created_at,
              :updated_at,
              :repository

  def initialize(data, repository)
    @id = data[:id].to_i
    @customer_id = data[:customer_id].to_i
    @merchant_id = data[:merchant_id].to_i
    @status = data[:status].to_sym
    @created_at = Time.parse(data[:created_at])
    @updated_at = Time.parse(data[:updated_at])
    @repository = repository
  end

  def merchant
    repository.merchant_by_invoice(merchant_id)
  end

  def items
    repository.get_matching_items(id)
  end

  def transactions
    repository.get_transactions_by_invoice_id(id)
  end

  def customer
    repository.customer_by_invoice(customer_id)
  end
end
