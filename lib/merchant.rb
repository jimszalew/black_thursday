require 'pry'
class Merchant

  attr_reader :id,
              :name,
              :repository

  def initialize(attributes, repository)
    @id   = attributes[:id].to_i
    @name = attributes[:name]
    @repository = repository
  end

  def items
    repository.all_merchant_items(id)
  end

  def invoices
    repository.all_merchant_invoices(id)
  end

  def customers
    repository.get_customers_by_merchant_id(id)
  end

  def total_revenue
    invoices.reduce(0) do |sum, invoice|
      sum + invoice.total
    end
  end
end
