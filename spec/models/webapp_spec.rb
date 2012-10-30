require 'spec_helper'

describe Webapp do
  
  before(:each) do
    @webapp = FactoryGirl.create(:webapp)
    @tag = Tag.new(:name=>"test")
  end
  
  
  # Methods test
  describe "Test methods" do
    
    # Existence
    it "should have a method taggedByTag?" do
      @webapp.should respond_to(:tagged_by_tag?)
    end

    it "shall have method called addTag! " do
      @webapp.should respond_to(:add_tag!)
    end

    it "shall have method called addTags! " do
      @webapp.should respond_to(:add_tags!)
    end

    # Good working
    it "method addTag! shall be add a good tag" do
      @tag.save
      @webapp.save
      @webapp.add_tag!(@tag)
      @webapp.tags.should include(@tag)
    end


    it "method addTags! shall be add goods tags" do
      @tags = ["test1","test2","test2"]
      @webapp.add_tags!(@tags)
      assert @webapp.tagged_by_tag?("test1")
      assert @webapp.tagged_by_tag?("test2")
   
      assert @webapp.tags.length == 2
    end


    it "method tagged? shall be return true if my webapp if tagged" do
      @tag2 = Tag.new(:name=>"tag2")
      @tag.save
      @webapp.save
      
      # Tag pas encore ajouté
      @webapp.add_tag!(@tag)
      @webapp.tagged_by_tag?(@tag).should be_true
     
      # Tag pas ajouté et inexistant en base
      @webapp.add_tag!("test3")
      @webapp.tagged_by_tag?("test3").should be_true
      
      #Tag pas ajouté
      @webapp.tagged_by_tag?(@tag2).should be_false
    end  
    
    it "method addTag! shall don't add tag if this tags already exists " do
      @tag.save
      @webapp.save
      @webapp.add_tag!(@tag)
      @webapp.add_tag!(@tag)
      @webapp.add_tag!("test")
      assert @webapp.tags.length == 1, "tag is not unique anymore "
    end 
    
  end

  describe "validation attributes" do
    it "webapp shall accept a valid url" do
      adresses = %w[www.lemonde.fr http://www.lemonde.fr https://www.facebook.fr]
      adresses.each do |address|
        @webapp.url =  address
        @webapp.should be_valid
      end
    end

    it "webapp shall do no accept a invalid url" do
      adresses = %w[wwwlemonde.fr http:www.lemonde.fr facebook.fr]
      adresses.each do |address|
        @webapp.url =  address
        @webapp.should be_valid
      end

    end
  end
    
end
