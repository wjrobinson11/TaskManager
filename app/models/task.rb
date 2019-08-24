# == Schema Information
#
# Table name: tasks
#
#  company_id  :integer
#  created_at  :datetime         not null
#  description :text
#  id          :bigint           not null, primary key
#  name        :string
#  price       :decimal(8, 2)
#  updated_at  :datetime         not null
#

class Task < ApplicationRecord
	belongs_to :company

	validates :name, presence: true, uniqueness: {scope: [:company_id], case_sensitive: false}
	validates :description, presence: true
	validates :price, presence: true
end
