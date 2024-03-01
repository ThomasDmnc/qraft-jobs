require 'date'
require_relative 'option'
class Rental
    attr_accessor :id, :car_id, :start_date, :end_date, :distance, :total_price, :options

    # Commissions 
    COMMISSION_RATE = 0.3
    INSURANCE_RATE = 0.5
    DAILY_ROAD_ASSISTANCE_FEE = 100
    # Retal Options
    GPS_PRICE_PER_DAY = 500
    BABY_SEAT_PRICE_PER_DAY = 200
    ADDITIONAL_INSURANCE_PRICE_PER_DAY = 1000

    def initialize(id, car_id, start_date, end_date, distance)
        @id = id
        @car_id = car_id
        @start_date = start_date
        @end_date = end_date
        @distance = distance
        @total_price = 0
        @options = []
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
        (calculate_total_commission - calculate_insurance_commission - calculate_road_assistance_fee + compute_drivy_options).to_i
    end 

    def calculate_owner_credit
        (calculate_price - calculate_total_commission + compute_owner_options).to_i
    end

    def add_options
        @options = Option.all.select {|option| option.rental_id == @id } 
    end

    def compute_owner_options
        options_total = 0
        @options.each do |option|
            case option.name
                when 'gps'
                    options_total += GPS_PRICE_PER_DAY
                when 'baby_seat'
                    options_total += BABY_SEAT_PRICE_PER_DAY
            end
        end
        options_total * rent_duration
    end

    def compute_all_options
        compute_owner_options + compute_drivy_options
    end

    def compute_drivy_options
        options_total = 0
        @options.each do |option|
            case option.name
                when 'additional_insurance'
                    options_total += ADDITIONAL_INSURANCE_PRICE_PER_DAY
            end
        end
        options_total * rent_duration
    end

    def total_driver_payment
        @total_price + compute_all_options
    end

    def return_rental_options
        add_options
        options = []
        @options.each do |option|
            options << option.name
        end
        options
    end


    def compute_all_commissions
        add_options
        calculate_price
        calculate_total_commission
        calculate_insurance_commission
        calculate_road_assistance_fee  
        calculate_drivy_commission
        calculate_owner_credit
        total_driver_payment
    end

    def actions_payment
        compute_all_commissions
        driver = { who: 'driver', type: 'debit', amount: total_driver_payment }
        owner = {who: 'owner', type: 'credit', amount: calculate_owner_credit }
        insurance = {who: 'insurance', type: 'credit', amount: calculate_insurance_commission }
        assistance = {who: 'assistance', type: 'credit', amount: calculate_road_assistance_fee }
        drivy = {who: 'drivy', type: 'credit', amount: calculate_drivy_commission }
        actions = [driver, owner, insurance, assistance, drivy]
    end
end