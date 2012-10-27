class User < ActiveRecord::Base
  attr_accessible :email, :firstname, :password, :surname
end
