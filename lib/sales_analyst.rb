class SalesAnalyst

  attr_reader :engine

  def initialize(engine)
    @engine = engine
  end

  def average_items_per_merchant
    (engine.items.all.count.to_f / engine.merchants.all.count).round(2)
  end

  def average_items_per_merchant_standard_deviation
    sos = engine.merchants.all.reduce(0) do |sum, merchant|
      sum + (merchant.items.count - average_items_per_merchant)**2
    end
    variance = sos / (engine.merchants.all.count - 1)
    (Math.sqrt(variance)).round(2)
  end

  def merchants_with_high_item_count
    std_dev = average_items_per_merchant_standard_deviation
    engine.merchants.all.find_all do |merchant|
      (merchant.items.count - average_items_per_merchant) > std_dev
    end
  end

  def average_item_price_for_merchant(merchant_id)
    merchant = engine.merchants.find_by_id(merchant_id)
    total_price = merchant.items.reduce(0) do |sum, item|
      sum + item.unit_price
    end
    return 0 if merchant.items.empty?
    (total_price / merchant.items.count).round(2)
  end

  def average_average_price_per_merchant
    total_average = engine.merchants.all.reduce(0) do |sum, merchant|
      sum + average_item_price_for_merchant(merchant.id)
    end
    (total_average / engine.merchants.all.count).round(2)
  end

  def average_item_price
    total_items = engine.items.all.count
    total_price = engine.items.all.reduce(0) do |sum, item|
      sum + item.unit_price
    end
    (total_price / total_items).round(2)
  end

  def average_item_price_standard_deviation
    sos = engine.items.all.reduce(0) do |sum, item|
      sum + (item.unit_price - average_item_price)**2
    end
    variance = sos / (engine.items.all.count - 1)
    (Math.sqrt(variance)).round(2)
  end

  def golden_items
    std_dev = average_item_price_standard_deviation
    average = average_average_price_per_merchant
    engine.items.all.find_all do |item|
      (item.unit_price - average) > (2 * std_dev)
    end
  end

  def average_invoices_per_merchant
    (engine.invoices.all.count.to_f / engine.merchants.all.count).round(2)
  end

  def average_invoices_per_merchant_standard_deviation
    sos = engine.merchants.all.reduce(0) do |sum, merchant|
      sum + (merchant.invoices.count - average_invoices_per_merchant)**2
    end
    variance = sos / (engine.merchants.all.count - 1)
    (Math.sqrt(variance)).round(2)
  end

  def top_merchants_by_invoice_count
    std_dev = average_invoices_per_merchant_standard_deviation
    engine.merchants.all.find_all do |merchant|
      (merchant.invoices.count - average_invoices_per_merchant) > (2 * std_dev)
    end
  end

  def bottom_merchants_by_invoice_count
    std_dev = average_invoices_per_merchant_standard_deviation
    engine.merchants.all.find_all do |merchant|
      (merchant.invoices.count - average_invoices_per_merchant) < (-2 * std_dev)
    end
  end

  def average_invoices_per_day
    (engine.invoices.all.count / 7.0).round(2)
  end

  def invoices_per_day_standard_deviation
    sos = engine.invoices_by_weekday.values.reduce(0) do |sum, value|
      sum + (value - average_invoices_per_day)**2
    end
    variance = sos / (6)
    (Math.sqrt(variance)).round(2)
  end

  def top_days_by_invoice_count
    std_dev = invoices_per_day_standard_deviation
    inv_by_day = engine.invoices_by_weekday

    inv_by_day.keys.find_all do |day|
      (inv_by_day[day] - average_invoices_per_day) > std_dev
    end
  end

  def invoice_status(status)
    all_invoices = engine.invoices.all.count
    percentage = (engine.invoices_by_status[status].to_f / all_invoices) * 100.0
    percentage.round(2)
  end

  def total_revenue_by_date(date)
    invoices = engine.invoices.find_all_by_date(date)

    invoices.reduce(0) do |sum, invoice|
      sum + invoice.total
    end
  end


  def merchants_ranked_by_revenue
    engine.merchants_by_total_revenue
  end

  def top_revenue_earners(range=20)
    engine.merchants_by_total_revenue[0..(range - 1)]
  end

  def merchants_with_pending_invoices
    invoices = engine.invoices.all.find_all do |invoice|
      !invoice.is_paid_in_full?
    end

    pending = invoices.map do |invoice|
      invoice.merchant
    end

    pending.uniq
  end

  def merchants_with_only_one_item
    engine.get_merchants_with_only_one_item
  end

  def merchants_with_only_one_item_registered_in_month(month)
    merchants_with_only_one_item.find_all do |merchant|
      merchant.created_at.strftime('%B') == month
    end
  end

  def revenue_by_merchant(merchant_id)
    engine.get_merchant_total_revenue(merchant_id)
  end

  def most_sold_item_for_merchant(merchant_id)
    merch = engine.find_merchant_by_id(merchant_id)
    most_sold = merch.invoice_items.reduce({}) do |quantities, inv_item|
      quantity = inv_item.quantity
      if quantities.has_key?(quantity)
        quantities[quantity] << engine.find_item_by_id(inv_item.item_id)
      else
        quantities[quantity] = [engine.find_item_by_id(inv_item.item_id)]
      end
      quantities
    end

    most_sold[most_sold.keys.max]
  end

  def best_item_for_merchant(merchant_id)
    merchant = engine.find_merchant_by_id(merchant_id)
    best_items = merchant.invoice_items.reduce({}) do |quantities, inv_item|
      revenue = inv_item.quantity * inv_item.unit_price
      quantities[revenue] = engine.find_item_by_id(inv_item.item_id)
      quantities
    end

    best_items[best_items.keys.max]
  end
end
