class Car
    attr_accessor :id, :price_per_day, :price_per_km
    def initialize(id, price_per_day, price_per_km)
        @id = id
        @price_per_day = price_per_day
        @price_per_km = price_per_km
    end

    def self.all
        ObjectSpace.each_object(Car).to_a
    end

    def self.find_by_id(id)
        Car.all.find { |car| car.id == id }
    end
end