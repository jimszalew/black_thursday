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

  def merchant_by_invoice(merchant_id)
    engine.merchant_by_invoice(merchant_id)
  end

  def get_matching_items(invoice_id)
    engine.get_items_by_invoice_id(invoice_id)
  end

  def get_transactions_by_invoice_id(invoice_id)
    engine.get_transactions_by_invoice_id(invoice_id)
  end

  def customer_by_invoice(customer_id)
    engine.customer_by_invoice(customer_id)
  end

  def merchant_ids_by_customer_id(customer_id)
    find_all_by_customer_id(customer_id).map do |invoice|
      invoice.merchant_id
    end
  end

  def customer_ids_by_merchant_id(merchant_id)
    find_all_by_merchant_id(merchant_id).map do |invoice|
      invoice.customer_id
    end
  end

  def get_invoice_items_by_invoice(invoice_id)
    engine.get_invoice_items_by_invoice(invoice_id)
  end

  def inspect
    "#<#{self.class} #{@invoices.size} rows>"
  end
end
