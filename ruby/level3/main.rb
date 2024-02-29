require_relative './models/database'

db = Database.new('./data/input.json')
db.parse_data_from_file
db.export_results_to_file