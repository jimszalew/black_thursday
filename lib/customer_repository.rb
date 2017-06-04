require_relative 'customer'

class CustomerRepository

  attr_reader :customers

  def initialize(csv, engine)
    @customers = {}
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
end
