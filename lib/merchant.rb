require 'pry'
require 'time'
class Merchant

  attr_reader :id,
              :name,
              :repository,
              :created_at

  def initialize(attributes, repository)
    @id   = attributes[:id].to_i
    @name = attributes[:name]
    @created_at = Time.parse(attributes[:created_at])

    @repository = repository
  end

  def items
    repository.all_merchant_items(id)
  end

  def invoices
    repository.all_merchant_invoices(id)
  end

  def paid_invoices
    invoices.find_all do |invoice|
      invoice.is_paid_in_full?
    end
  end

  def invoice_items
    paid_invoices.map do |invoice|
      invoice.invoice_items
    end.flatten
  end

  def customers
    repository.get_customers_by_merchant_id(id)
  end

  def total_revenue
    invoices.reduce(0) do |sum, invoice|
      sum + invoice.total
    end
  end

  def pending_invoice?
    invoices.any? do |invoice|
      invoice.status == :pending
    end
  end
end
