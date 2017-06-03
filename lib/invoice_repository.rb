require_relative 'invoice'

class InvoiceRepository
  attr_reader :invoices
  def initialize(csv, engine)
    @invoices = {}
    @engine = engine
    self.add(csv)
  end

  def add(csv)
    csv.each do |row|
      stuff = row.to_h
      invoices[stuff[:id]] = Invoice.new(stuff, self)
    end
  end
end
