class InvoiceItem

  attr_reader :id,
              :item_id,
              :invoice_id,
              :quantity,
              :unit_price,
              :created_at,
              :updated_at

  def initialize(data)
    @id = data[:id]
    @item_id = data[:item_id]
    @invoice_id = data[:invoice_id]
    @quantity = data[:quantity]
    @unit_price = (BigDecimal.new(((data[:unit_price].to_i)/100.0), 0)).round(2)
    @created_at = Time.parse(data[:created_at])
    @updated_at = Time.parse(data[:created_at])
  end


end
