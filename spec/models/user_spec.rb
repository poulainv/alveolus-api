require 'spec_helper'

describe " associations with comments" do

  before(:each) do
    @user1 = FactoryGirl.create(:user)
    @user2 = FactoryGirl.create(:user)
    @user3 = FactoryGirl.create(:user)
    @webapp1 = FactoryGirl.create(:webapp, :user => @user1)
    @webapp2 = FactoryGirl.create(:webapp, :user => @user2)
    @mp1 = FactoryGirl.create(:comment, :user => @user1, :webapp => @webapp1, :created_at => 1.day.ago)
    @mp2 = FactoryGirl.create(:comment, :user => @user1,:webapp => @webapp2,  :created_at => 3.hour.ago)
    @mp3 = FactoryGirl.create(:comment, :user => @user2,:webapp => @webapp1,  :created_at => 2.hour.ago)
    @mp4 = FactoryGirl.create(:comment, :user => @user3,:webapp => @webapp1,  :created_at => 1.hour.ago)
  end

  it "shall have an attribute 'comment'" do
    @user1.should respond_to(:comments)
    
  end

  it "shall have goods comments in a good order (DESC)" do
    @user1.comments.should == [@mp2, @mp1]
  end


  it "shall destroy comment associated" do
    @user1.destroy
    [@mp1, @mp2].each do |comment|
      Comment.find_by_id(comment.id).should be_nil
    end
  end

  it "shall destroy comment associated" do
    @user1.destroy
    [@mp1, @mp2].each do |comment|
      Comment.find_by_id(comment.id).should be_nil
    end
  end

  it "shall have some correct notifications" do
    @mp1.notify_new_comment
    @mp2.notify_new_comment
    @mp3.notify_new_comment
    @mp4.notify_new_comment
    @user1.notifications.length.should == 2 
    @user2.notifications.length.should == 3
    @user3.notifications.length.should == 2
  end
end