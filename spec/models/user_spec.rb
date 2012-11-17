require 'spec_helper'

describe " associations with comments" do

  before(:each) do
    @user = FactoryGirl.create(:user)
    @mp1 = FactoryGirl.create(:comment, :user => @user, :created_at => 1.day.ago)
    @mp2 = FactoryGirl.create(:comment, :user => @user, :created_at => 1.hour.ago)
  end

  it "shall have an attribute 'comment'" do
    @user.should respond_to(:comments)
    
  end

  it "shall have goods comments in a good order (DESC)" do
    @user.comments.should == [@mp2, @mp1]
  end


  it "shall destroy comment associated" do
    @user.destroy
    [@mp1, @mp2].each do |comment|
      Comment.find_by_id(comment.id).should be_nil
    end

  end
end