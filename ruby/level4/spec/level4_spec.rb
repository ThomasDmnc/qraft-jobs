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

    it 'should calculate the total price of the rental for 1 day without any discount' do
        car = Car.new(1, 2000, 10)
        rental = Rental.new(1, 1, '2015-12-8', '2015-12-8', 100)
        rental.calculate_price
        expect(rental.total_price).to eq(3000)
    end

    it 'should calculate the total price of the rental for 2 days with a discount' do
        car = Car.new(1, 2000, 10)
        rental = Rental.new(1, 1, '2015-03-31', '2015-04-01', 300)
        rental.calculate_price
        expect(rental.total_price).to eq(6800)
    end

    it 'should calculate the total price of the rental for +5 days with a discount' do
        car = Car.new(1, 2000, 10)
        rental = Rental.new(1, 1, '2015-03-31', '2015-04-05', 300)
        rental.calculate_price
        expect(rental.total_price).to eq(13200)
    end

    it 'should calculate the total price of the rental for 12 days with a discount' do
        car = Car.new(1, 2000, 10)
        rental = Rental.new(1, 1, '2015-07-3', '2015-07-14', 1000)
        rental.calculate_price
        expect(rental.total_price).to eq(27800)
    end

    it 'should calculate the total commission' do
        car = Car.new(1, 2000, 10)
        rental = Rental.new(1, 1, '2015-12-8', '2015-12-8', 100)
        rental.calculate_price
        expect(rental.calculate_total_commission).to eq(900)
    end

    it 'should calculate the insurance commission' do
        car = Car.new(1, 2000, 10)
        rental = Rental.new(1, 1, '2015-12-8', '2015-12-8', 100)
        rental.calculate_price
        expect(rental.calculate_insurance_commission).to eq(450)
    end
    
    it 'should calculate the road assistance fee' do
        car = Car.new(1, 2000, 10)
        rental = Rental.new(1, 1, '2015-12-8', '2015-12-8', 100)
        rental.calculate_price
        expect(rental.calculate_road_assistance_fee).to eq(100)
    end
    
    it 'should calculate the drivy commissions' do
        car = Car.new(1, 2000, 10)
        rental = Rental.new(1, 1, '2015-12-8', '2015-12-8', 100)
        rental.calculate_price
        expect(rental.calculate_drivy_commission).to eq(350)
    end

    it 'should calculate all the payments actions correctly' do
        car = Car.new(1, 2000, 10)
        rental = Rental.new(1, 1, '2015-12-8', '2015-12-8', 100)
        rental.compute_all_commissions
        expect(rental.actions_payment).to eq([
            {
              "who": "driver",
              "type": "debit",
              "amount": 3000
            },
            {
              "who": "owner",
              "type": "credit",
              "amount": 2100
            },
            {
              "who": "insurance",
              "type": "credit",
              "amount": 450
            },
            {
              "who": "assistance",
              "type": "credit",
              "amount": 100
            },
            {
              "who": "drivy",
              "type": "credit",
              "amount": 350
            }
          ])
    end
end