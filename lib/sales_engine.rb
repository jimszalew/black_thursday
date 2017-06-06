require_relative "item_repository"
require_relative "merchant_repository"
require_relative "invoice_repository"
require_relative "invoice_item_repository"
require_relative "transaction_repository"
require_relative "customer_repository"

class SalesEngine

  attr_reader :items,
              :merchants,
              :invoices,
              :invoice_items,
              :transactions,
              :customers

  def initialize(item_rows, merchant_rows, invoice_rows, invoice_item_rows, transaction_rows, customer_rows)
    @items     = ItemRepository.new(item_rows, self)
    @merchants = MerchantRepository.new(merchant_rows, self)
    @invoices = InvoiceRepository.new(invoice_rows, self)
    @invoice_items = InvoiceItemRepository.new(invoice_item_rows, self)
    @transactions = TransactionRepository.new(transaction_rows, self)
    @customers = CustomerRepository.new(customer_rows, self)

  end

  def self.from_csv(paths)
    item_path  = paths[:items]
    merch_path = paths[:merchants]
    invoice_path = paths[:invoices]
    invoice_item_path = paths[:invoice_items]
    transactions_path = paths[:transactions]
    customers_path = paths[:customers]

    item_data  = CSV.open item_path, headers: true, header_converters: :symbol
    merch_data = CSV.open merch_path, headers: true, header_converters: :symbol
    invoice_data = CSV.open invoice_path, headers: true, header_converters: :symbol
    invoice_items_data = CSV.open invoice_item_path, headers: true, header_converters: :symbol
    transactions_data = CSV.open transactions_path, headers: true, header_converters: :symbol
    customer_data = CSV.open customers_path, headers: true, header_converters: :symbol

    SalesEngine.new(item_data, merch_data, invoice_data, invoice_items_data, transactions_data, customer_data)
  end

  def all_merchant_items(merchant_id)
    items.find_all_by_merchant_id(merchant_id)
  end

  def merchant_by_item(merchant_id)
    merchants.find_by_id(merchant_id.to_s)
  end

  def all_merchant_invoices(merchant_id)
    invoices.find_all_by_merchant_id(merchant_id)
  end

  def merchant_by_invoice(merchant_id)
    merchants.find_by_id(merchant_id.to_s)
  end

  def invoices_by_weekday
    days = {}
    invoices.all.each do |invoice|
      if days.has_key?(invoice.created_at.strftime('%A'))
        days[invoice.created_at.strftime('%A')] += 1
      else
        days[invoice.created_at.strftime('%A')] = 1
      end
    end
    days
  end

  def invoices_by_status
    status = {}
    invoices.all.each do |invoice|
      if status.has_key?(invoice.status.to_sym)
        status[invoice.status.to_sym] += 1
      else
        status[invoice.status.to_sym] = 1
      end
    end
    status
  end

  def item_ids_by_invoice_id(invoice_id)
    invoice_items.item_ids_by_invoice_id(invoice_id)
  end

  def get_items_by_invoice_id(invoice_id)
    item_ids = item_ids_by_invoice_id(invoice_id)
    items.get_matching_items(item_ids)
  end

  def get_transactions_by_invoice_id(invoice_id)
    transactions.find_all_by_invoice_id(invoice_id)
  end

  def customer_by_invoice(customer_id)
    customers.find_by_id(customer_id)
  end

  def invoice_by_transaction(invoice_id)
    invoices.find_by_id(invoice_id)
  end

  def merchant_ids_by_customer_id(customer_id)
    invoices.merchant_ids_by_customer_id(customer_id)
  end

  def get_merchants_by_customer_id(customer_id)
    merchant_ids = merchant_ids_by_customer_id(customer_id)
    merchants.get_matching_merchants(merchant_ids)
  end

  def customer_ids_by_merchant_id(merchant_id)
    invoices.customer_ids_by_merchant_id(merchant_id)
  end

  def get_customers_by_merchant_id(merchant_id)
    customer_ids = customer_ids_by_merchant_id(merchant_id)
    customers.get_matching_customers(customer_ids)
  end

  def get_invoice_items_by_invoice(invoice_id)
    invoice_items.find_all_by_invoice_id(invoice_id)
  end

  def get_total_revenue_by_date
    invoice_items.total_revenue_by_date
  end

  def get_merchants_with_pending_invoices
    merchants.merchants_with_pending_invoices
  end

  def get_merchants_with_only_one_item
    merchants.merchants_with_only_one_item
  end

  def get_merchant_total_revenue(merchant_id)
    merchants.find_by_id(merchant_id).total_revenue
  end
end
