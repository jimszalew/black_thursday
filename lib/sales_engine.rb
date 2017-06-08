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

  def initialize(item, merchant, invoice, invoice_item, transaction, customer)
    @items     = ItemRepository.new(item, self)
    @merchants = MerchantRepository.new(merchant, self)
    @invoices = InvoiceRepository.new(invoice, self)
    @invoice_items = InvoiceItemRepository.new(invoice_item, self)
    @transactions = TransactionRepository.new(transaction, self)
    @customers = CustomerRepository.new(customer, self)
  end

  def self.from_csv(paths)
    item_loc  = paths[:items]
    merch_loc = paths[:merchants]
    invoice_loc = paths[:invoices]
    inv_item_loc = paths[:invoice_items]
    transacs_loc = paths[:transactions]
    customers_loc = paths[:customers]

    item  = CSV.open item_loc, headers: true, header_converters: :symbol
    merch = CSV.open merch_loc, headers: true, header_converters: :symbol
    invoice = CSV.open invoice_loc, headers: true, header_converters: :symbol
    inv_items = CSV.open inv_item_loc, headers: true, header_converters: :symbol
    transacs = CSV.open transacs_loc, headers: true, header_converters: :symbol
    customer = CSV.open customers_loc, headers: true, header_converters: :symbol

    SalesEngine.new(item, merch, invoice, inv_items, transacs, customer)
  end

  def all_merchant_items(merchant_id)
    items.find_all_by_merchant_id(merchant_id)
  end

  def find_merchant_by_id(merchant_id)
    merchants.find_by_id(merchant_id)
  end

  def merchant_by_item(merchant_id)
    merchants.find_by_id(merchant_id)
  end

  def all_merchant_invoices(merchant_id)
    invoices.find_all_by_merchant_id(merchant_id)
  end

  def merchant_by_invoice(merchant_id)
    merchants.find_by_id(merchant_id)
  end

  def find_item_by_id(item_id)
    items.find_by_id(item_id)
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

  def get_merchants_with_only_one_item
    merchants.merchants_with_only_one_item
  end

  def get_merchant_total_revenue(merchant_id)
    merchants.find_by_id(merchant_id).total_revenue
  end

  def merchants_by_total_revenue
    merchants.merchants_by_total_revenue
  end
end
