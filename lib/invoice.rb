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

  def invoice_items
    repository.get_invoice_items_by_invoice(id)
  end

  def is_paid_in_full?
    return false if transactions.empty?
    transactions.any? do |transaction|
      transaction.result == "success"
    end
  end

  def total
    return 0 if !is_paid_in_full?
    total = invoice_items.reduce(0) do |sum, invoice_item|
      sum + (invoice_item.quantity.to_i * invoice_item.unit_price)
    end
    total
  end
end
