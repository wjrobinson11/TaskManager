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

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :validatable

  TYPES = ['SuperAdmin', 'TaskAdmin']

  belongs_to :company, optional: true

  validates :type, inclusion: TYPES

  def super_admin?
  	self.is_a?(SuperAdmin)
  end

  def task_admin?
  	self.is_a?(TaskAdmin)
  end
end
