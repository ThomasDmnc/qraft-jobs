require_relative '../models/car'
require_relative '../models/rental'


describe Car do
    it 'should create a new car' do
        car = Car.new(1, 2000, 10)
        expect(car.id).to eq(1)
        expect(car.price_per_day).to eq(2000)
        expect(car.price_per_km).to eq(10)
    end

    it 'should find all cars' do
        car2 = Car.new(2, 3000, 15)
        expect(Car.all.count).to eq(2)
    end

    it 'should find a car by id' do
        car = Car.new(1, 2000, 10)
        car2 = Car.new(2, 3000, 15)
        expect(Car.find_by_id(2).id).to eq(car2.id)
    end

end

describe Rental do
    it 'should create a new rental' do
        rental = Rental.new(1, 1, '2015-12-8', '2015-12-8', 100)
        expect(rental.id).to eq(1)
        expect(rental.car_id).to eq(1)
        expect(rental.start_date).to eq('2015-12-8')
        expect(rental.end_date).to eq('2015-12-8')
        expect(rental.distance).to eq(100)
        expect(rental.total_price).to eq(0)
    end 
    it 'should calculate the total price of the rental' do
        car = Car.new(1, 2000, 10)
        rental = Rental.new(1, 1, '2017-12-8', '2017-12-10', 100)
        rental.calculate_price
        expect(rental.total_price).to eq(7000)
    end
end