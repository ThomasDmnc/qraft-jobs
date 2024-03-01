require 'date'
class Rental
    attr_accessor :id, :car_id, :start_date, :end_date, :distance, :total_price
    def initialize(id, car_id, start_date, end_date, distance)
        @id = id
        @car_id = car_id
        @start_date = start_date
        @end_date = end_date
        @distance = distance
        @total_price = 0
    end

    def self.all
        ObjectSpace.each_object(Rental).to_a
    end

    def rent_duration
        (DateTime.parse(@end_date) - DateTime.parse(@start_date)).to_i + 1
    end

    def calculate_price
        number_of_days = rent_duration
        car = Car.find_by_id(@car_id)
        price_per_day = number_of_days * car.price_per_day
        price_per_km = @distance * car.price_per_km
        @total_price = price_per_day + price_per_km
    end
end