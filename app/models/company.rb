# == Schema Information
#
# Table name: companies
#
#  created_at :datetime         not null
#  id         :bigint           not null, primary key
#  name       :string
#  updated_at :datetime         not null
#

class Company < ApplicationRecord
	has_many :task_admins
	has_many :tasks
end
