class Option
  attr_reader :id, :name, :rental_id

  def initialize(id, rental_id, name)
    @id = id
    @rental_id = rental_id
    @name = name
  end

  def self.all
    ObjectSpace.each_object(Option).to_a
end
end