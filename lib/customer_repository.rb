require_relative 'customer'

class CustomerRepository

  attr_reader :customers,
              :engine

  def initialize(csv, engine)
    @customers = {}
    @engine = engine
    self.add(csv)
  end

  def add(csv)
    csv.each do |row|
      stuff = row.to_h
      customers[stuff[:id].to_i] = Customer.new(stuff, self)
    end
  end

  def all
    customers.values
  end

  def find_by_id(id)
    customers[id]
  end

  def find_all_by_first_name(first_name)
    all.find_all do |customer|
      customer.first_name == first_name
    end
  end

  def find_all_by_last_name(last_name)
    all.find_all do |customer|
      customer.last_name == last_name
    end
  end

  def inspect
    "#<#{self.class} #{@customers.size} rows>"
  end
end
