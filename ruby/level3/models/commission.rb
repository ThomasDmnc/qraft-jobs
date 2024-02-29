require_relative 'rental'
class Commission
    attr_reader :rental

    COMMISSION_RATE = 0.3
    INSURANCE_RATE = 0.5
    DAILY_ROAD_ASSISTANCE_FEE = 100

    def initialize(rental)
        @rental = rental
    end

    def calculate_total_commission
        (@rental.total_price * COMMISSION_RATE).to_i

    end 

    def calculate_insurance_commission
        (calculate_total_commission * INSURANCE_RATE).to_i
    end

    def calculate_road_assistance_fee
        (@rental.rent_duration * DAILY_ROAD_ASSISTANCE_FEE).to_i
    end

    def calculate_drivy_commission
        (calculate_total_commission - calculate_insurance_commission - calculate_road_assistance_fee).to_i
    end 
end