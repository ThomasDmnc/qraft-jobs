require_relative './models/database'

db = Database.new('./data/input.json')
db.parse_data_from_file
db.export_actions_payment_results_to_file