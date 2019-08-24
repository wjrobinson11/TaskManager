# TaskManager

TaskManager is an application for managing tasks for different companies and assigning different users to those companies.
## Installation
Ruby version expected in this project is 2.5.3, Rails version 5.2.3

copy project, cd in and run:

	$ bundle install

## Set up database
Configured with Postgres database

	$ bundle exec rake db:create
    $ bundle exec rake db:migrate
    
## Start server
Start rails server locally for project

    $ rails server

## Seed data
Seed will start you off with a SuperAdmin, two TaskAdmins, two Companies, and two Tasks for each Company.

    $ bundle exec rake db:seed
    
## Login Credentials
Found in db/seeds.rb
    
        SuperAdmin email, password => admin@taskmanager.com, admin1234
        TaskAdmin1 email, password => task@company1.com, task1234
        TaskAdmin2 email, password => task@company2.com, task1234

Use these credentials to log in to the application running on localhost:3000/auth/sign_in   

## Run specs
To run all controller and model specs

    $ bundle exec rspec spec

Please reach out if you have any issues, thank you.
