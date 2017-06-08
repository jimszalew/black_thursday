require_relative 'merchant'
require 'csv'
require 'pry'

class MerchantRepository

  attr_reader :merchants,
              :engine

  def initialize(csv, engine)
    @merchants = {}
    @engine = engine
    self.add(csv)

  end

  def add(csv)
    csv.each do |row|
      stuff = row.to_h
      merchants[stuff[:id].to_i] = Merchant.new(stuff, self)
    end
  end

  def all
    merchants.values
  end

  def find_by_id(id)
    merchants[id]
  end

  def find_by_name(name)
    all.find { |merchant| merchant.name.downcase == name.downcase }
  end

  def find_all_by_name(name_frag)
    all.find_all do |merchant|
      merchant.name.downcase.include?(name_frag.downcase)
    end
  end

  def all_merchant_items(merchant_id)
    engine.all_merchant_items(merchant_id)
  end

  def all_merchant_invoices(merchant_id)
    engine.all_merchant_invoices(merchant_id)
  end

  def get_matching_merchants(merchant_ids)
    all.find_all do |merchant|
      merchant_ids.include?(merchant.id)
    end
  end

  def get_customers_by_merchant_id(merchant_id)
    engine.get_customers_by_merchant_id(merchant_id)
  end

  def merchants_by_total_revenue
    all.sort_by { |merchant| merchant.total_revenue }.reverse
  end

  def merchants_with_pending_invoices
    all.find_all do |merchant|
      merchant.pending_invoice?
    end
  end

  def merchants_with_only_one_item
    all.find_all do |merchant|
      merchant.items.count == 1
    end
  end

  def inspect
    "#<#{self.class} #{@merchants.size} rows>"
  end
end
