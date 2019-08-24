# == Schema Information
#
# Table name: users
#
#  company_id             :integer
#  created_at             :datetime         not null
#  email                  :string           default(""), not null, indexed
#  encrypted_password     :string           default(""), not null
#  first_name             :string
#  id                     :bigint           not null, primary key
#  last_name              :string
#  reset_password_sent_at :datetime
#  reset_password_token   :string           indexed
#  type                   :string
#  updated_at             :datetime         not null
#

class TaskAdmin < User
	validates :company, presence: true
end
