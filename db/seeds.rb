# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

if Rails.env.development?
	puts "Running seed file..."
	# Clear data
	User.destroy_all
	Company.destroy_all
	Task.destroy_all

	# Create SuperAdmin
	SuperAdmin.create!(
		email: 'admin@taskmanager.com',
		password: 'admin1234'
	)

	# Create company 1
	c1 = Company.create!(name: "Company 1")
	# Create TaskAdmin for company 1
	TaskAdmin.create!(email: 'task@company1.com', password: 'task1234', company_id: c1.id)
	Task.create!(
		name: "Leaky Faucet",
		description: "Faucet has been leaking for months due to cracked pipes.",
		price: 100.0,
		company_id: c1.id
	)
	Task.create!(
		name: "Radiator Broken",
		description: "Radiator stopped working and needs new valve.",
		price: 59.99,
		company_id: c1.id
	)

	# Create company 2
	c2 = Company.create!(name: "Company 2")
	# Create TaskAdmin for company 2
	TaskAdmin.create!(email: 'task@company2.com', password: 'task1234', company_id: c2.id)
	Task.create!(
		name: "Shower Installation",
		description: "Need to install new walk in shower 5'' by 8''",
		price: 4000.0,
		company_id: c2.id
	)
	Task.create!(
		name: "Hot Water Heater Replacement",
		description: "Replace old water heater with new one.",
		price: 1000,
		company_id: c2.id
	)
	puts "Successfully ran seed file!"
end
