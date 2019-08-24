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
	has_many :task_admins, dependent: :destroy
	has_many :tasks, dependent: :destroy

	validates :name, presence: true, uniqueness: {case_sensitive: false}

end
