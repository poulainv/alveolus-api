# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  surname    :string(255)
#  firstname  :string(255)
#  email      :string(255)
#  password   :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
