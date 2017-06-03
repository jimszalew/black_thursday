require_relative "item_repository"
require_relative "merchant_repository"
require_relative "invoice_repository"

class SalesEngine

  attr_reader :items,
              :merchants,
              :invoices

  def initialize(item_rows, merchant_rows, invoice_rows)
    @items     = ItemRepository.new(item_rows, self)
    @merchants = MerchantRepository.new(merchant_rows, self)
    @invoices = InvoiceRepository.new(invoice_rows, self)
  end

  def self.from_csv(paths)
    item_path  = paths[:items]
    merch_path = paths[:merchants]
    invoice_path = paths[:invoices]

    item_data  = CSV.open item_path, headers: true, header_converters: :symbol
    merch_data = CSV.open merch_path, headers: true, header_converters: :symbol
    invoice_data = CSV.open invoice_path, headers: true, header_converters: :symbol

    SalesEngine.new(item_data, merch_data, invoice_data)
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
end
