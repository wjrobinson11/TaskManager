# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

if Rails.env.development?
	# Clear data
	User.destroy_all
	Company.destroy_all
	Task.destroy_all

	# Create SuperAdmin
	SuperAdmin.create!(
		email: 'admin@serviceshift.com',
		password: 'admin1234'
	)

	# Create company 1
	c1 = Company.create!(name: "Billy Go")
	# Create TaskAdmin for company 1
	TaskAdmin.create!(email: 'task@billygo.com', password: 'task1234', company_id: c1.id)

	# Create company 2
	c2 = Company.create!(name: "Berkeys")
	# Create TaskAdmin for company 2
	TaskAdmin.create!(email: 'task@berkeys.com', password: 'task1234', company_id: c2.id)
end
