require 'time'
require_relative 'invoice_item'
require 'pry'

class InvoiceItemRepository

  attr_reader :invoice_items,
              :engine

  def initialize(csv, engine)
    @invoice_items = {}
    @engine = engine
    self.add(csv)
  end

  def add(csv)
    csv.each do |row|
      data = row.to_h
      invoice_items[data[:id].to_i] = InvoiceItem.new(data, self)
    end
  end

  def all
    invoice_items.values
  end

  def find_by_id(id)
    invoice_items[id]
  end

  def find_all_by_item_id(item_id)
    all.find_all do |invoice_item|
      invoice_item.item_id == item_id
    end
  end

  def find_all_by_invoice_id(invoice_id)
    all.find_all do |invoice_item|
      invoice_item.invoice_id == invoice_id
    end
  end

  def item_ids_by_invoice_id(invoice_id)
    find_all_by_invoice_id(invoice_id).map do |invoice_item|
      invoice_item.item_id
    end
  end

  def total_revenue_by_date
    dates = {}
    all.each do |invoice_item|

      created = (invoice_item.created_at)
      if dates.has_key?(created)
        dates[created] += (invoice_item.unit_price * invoice_item.quantity.to_f)
      else
        dates[created] = (invoice_item.unit_price * invoice_item.quantity.to_f)
      end
    end
    dates
  end

  def inspect
    "#<#{self.class} #{@invoice_items.size} rows>"
  end
end
