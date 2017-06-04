require_relative 'invoice_item'

class InvoiceItemRepository

  attr_reader :invoice_items

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

end
