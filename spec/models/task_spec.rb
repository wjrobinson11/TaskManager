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

require 'rails_helper'

RSpec.describe Task, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
