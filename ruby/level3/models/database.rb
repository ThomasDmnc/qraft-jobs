require 'json'
require_relative 'car'
require_relative 'rental'

file = File.read('./data/input.json')
data = JSON.parse(file)

class Database
    def initialize(file_path)
        @cars = []
        @rentals = []
        @file_path = file_path
    end

    def parse_data_from_file
        file = File.read(@file_path)
        data = JSON.parse(file)

        data['cars'].each do |car|
            newCar = Car.new(car['id'], car['price_per_day'], car[('price_per_km')])
            @cars << newCar
        end

        data['rentals'].each do |rental|
            rental = Rental.new(rental['id'], rental['car_id'], rental['start_date'], rental['end_date'], rental['distance'])
            rental.calculate_price
            @rentals << rental
        end
    end

    def export_results_to_file
        rentals = []
        @rentals.each do |rental|
            rentals << { id: rental.id, price: rental.total_price, commission: {insurance_fee: rental.calculate_insurance_commission, assistance_fee: rental.calculate_road_assistance_fee, drivy_fee: rental.calculate_drivy_commission}}
        end

        File.open('./data/output.json', 'w') do |f|
            f.write(JSON.pretty_generate({ rentals: rentals }))
        end
    end
end