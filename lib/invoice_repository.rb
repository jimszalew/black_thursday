require_relative 'invoice'

class InvoiceRepository
  attr_reader :invoices,
              :engine
  def initialize(csv, engine)
    @invoices = {}
    @engine = engine
    self.add(csv)
  end

  def add(csv)
    csv.each do |row|
      stuff = row.to_h
      invoices[stuff[:id].to_i] = Invoice.new(stuff, self)
    end
  end

  def all
    invoices.values
  end

  def find_by_id(invoice_id)
    invoices[invoice_id]
  end

  def find_all_by_customer_id(customer_id)
    all.find_all do |invoice|
      invoice.customer_id == customer_id
    end
  end

  def find_all_by_merchant_id(merchant_id)
    all.find_all do |invoice|
      invoice.merchant_id == merchant_id
    end
  end

  def find_all_by_status(status)
    all.find_all do |invoice|
      invoice.status == status
    end
  end
end