class InvoiceItem

  attr_reader :id,
              :item_id

  def initialize(data)
    @id = data[:id]
    @item_id = data[:item_id]
  end


end
