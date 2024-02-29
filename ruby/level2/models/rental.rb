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

    def calculate_price_per_day(number_of_days, car_price_per_day)
        total_price = 0
        for index in (1..number_of_days).to_a do
            discount = 1
            if index > 10
                discount = 0.5
            elsif index > 4
                discount = 0.7
            elsif index > 1
                discount = 0.9
            end
            total_price += car_price_per_day * discount
        end
        return total_price
    end

    def calculate_price
        number_of_days = rent_duration
        car = Car.find_by_id(@car_id)
        price_per_day = calculate_price_per_day(number_of_days, car.price_per_day)
        price_per_km = @distance * car.price_per_km
        @total_price =( price_per_day + price_per_km).to_i
    end
end