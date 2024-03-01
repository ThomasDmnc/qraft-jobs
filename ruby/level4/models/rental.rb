require 'date'
class Rental
    attr_accessor :id, :car_id, :start_date, :end_date, :distance, :total_price

    COMMISSION_RATE = 0.3
    INSURANCE_RATE = 0.5
    DAILY_ROAD_ASSISTANCE_FEE = 100

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
        @total_price = (price_per_day + price_per_km).to_i
    end

    def calculate_total_commission
        (@total_price * COMMISSION_RATE).to_i
    end 

    def calculate_insurance_commission
        (calculate_total_commission * INSURANCE_RATE).to_i
    end

    def calculate_road_assistance_fee
        (rent_duration * DAILY_ROAD_ASSISTANCE_FEE).to_i
    end

    def calculate_drivy_commission
        (calculate_total_commission - calculate_insurance_commission - calculate_road_assistance_fee).to_i
    end 

    def calculate_owner_credit
        calculate_price - calculate_total_commission
    end

    def compute_all_commissions
        calculate_price
        calculate_total_commission
        calculate_insurance_commission
        calculate_road_assistance_fee  
        calculate_drivy_commission
        calculate_owner_credit
    end

    def actions_payment
        compute_all_commissions
        driver = { who: 'driver', type: 'debit', amount: @total_price }
        owner = {who: 'owner', type: 'credit', amount: calculate_owner_credit }
        insurance = {who: 'insurance', type: 'credit', amount: calculate_insurance_commission }
        assistance = {who: 'assistance', type: 'credit', amount: calculate_road_assistance_fee }
        drivy = {who: 'drivy', type: 'credit', amount: calculate_drivy_commission }
        actions = [driver, owner, insurance, assistance, drivy]
    end
end