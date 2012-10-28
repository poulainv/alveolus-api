require 'spec_helper'

describe Tag do
  
  before(:each) do
    @tag = Tag.new
  end
  
  
  describe "method for tag" do
    it "should have a method tagged?" do
      @tag.should respond_to(:tagged?)
    end
    
     it "method tagged? shall be return true if my webapp if tagged" do
      @webapp = FactoryGirl.build(:webapp)
      @webapp2 = Webapp.new(:title=>"webapp2",:caption=>"caption1",:url=>"www.tgt.fr",:validate => true,:description=> "desc1")
      @tag.save
      @webapp.save
      @webapp.addTag!(@tag)
      @tag.tagged?(@webapp).should be_true
      @tag.tagged?(@webapp2).should be_false

    end  
    
  end
  
  describe "attibrute has_many webApps and tagAppRelations" do
    it "shall have a method called webApps" do
      @tag.should respond_to(:webapps)
    end
     it "shall have a method called tagAppRelations" do
      @tag.should respond_to(:tagAppRelations)
    end
  end
  
end
