class Customer

  attr_reader :id

  def initialize(data, repository)
    @id = data[:id].to_i
  end
end
