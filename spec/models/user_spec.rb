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

require 'spec_helper'

describe User do
  pending "add some examples to (or delete) #{__FILE__}"
end
