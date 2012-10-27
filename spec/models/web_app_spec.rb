require 'spec_helper'

describe WebApp do
  
  before(:each) do
     @webapp = WebApp.new(:title=>"webapp1",:caption=>"caption1",:url=>"www.tgt.fr",:validate => true,:description=> "desc1")
     @tag = Tag.new(:name=>"test")
  end
  
   describe "method for tag" do
    it "should have a method taggedByTag?" do
      @webapp.should respond_to(:taggedByTag?)
    end

    it "shall have method called addTag " do
      @webapp.should respond_to(:addTag!)
    end
    
    it "method addTag! shall be add a good tag" do
      @tag.save
      @webapp.save
      @webapp.addTag!(@tag)
      @webapp.tags.should include(@tag)
    end  
    
     it "method tagged? shall be return true if my webapp if tagged" do
      @tag2 = Tag.new(:name=>"tag2")
      @tag.save
      @webapp.save
      
      # Tag pas encore ajouté
      @webapp.addTag!(@tag)
      @webapp.taggedByTag?(@tag).should be_true
     
      # Tag pas ajouté et inexistant en base
      @webapp.addTag!("test3")
      @webapp.taggedByTag?("test3").should be_true
      
      #Tag pas ajouté
      @webapp.taggedByTag?(@tag2).should be_false
    end  
    
    it "method addTag! shall don't add tag if this tags already exists " do
      @tag.save
      @webapp.save
      @webapp.addTag!(@tag)
      @webapp.addTag!(@tag)
      @webapp.addTag!("test")
      @webapp.tags.length == 1
    end 
    
  end

end
