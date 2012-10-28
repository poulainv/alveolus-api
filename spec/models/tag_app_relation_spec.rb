require 'spec_helper'

describe TagAppRelation do

  before(:each) do
    @tag = Tag.new(:name=>"test")
    @tag.save
    @webapp = FactoryGirl.build(:webapp)
    @webapp.save
    @relationship = @tag.tagAppRelations.build(:webapp_id => @webapp.id)
  end

  it "shall have valide attributes" do
    @relationship.save!
  end
  
  describe "Method to find webapp" do

      before(:each) do
        @relationship.save
      end
  
      it "shall have an attribute webApp" do
        @relationship.should respond_to(:webapp)
      end
  
      it "shall have a good webapp associated" do
        @relationship.webapp.should == @webapp
      end
    
      it "shall have an attribute tag" do
        @relationship.should respond_to(:tag)
      end
  
      it "shave have a good tag associated" do
        @relationship.tag.should == @tag
      end

   
  end
  
  
  describe "validations" do

    it "shall need webapp.id" do
      @relationship.webapp_id = nil
      @relationship.should_not be_valid
    end

    it "shall need tag.id" do
      @relationship.tag_id = nil
      @relationship.should_not be_valid
    end
  end
  
end
