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
end
