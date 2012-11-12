# == Schema Information
#
# Table name: webapps
#
#  id               :integer          not null, primary key
#  title            :string(255)
#  caption          :string(255)
#  description      :string(255)
#  validate         :boolean
#  url              :string(255)
#  average_rate     :float
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  image            :string(255)
#  nb_click_preview :integer
#  nb_click_detail  :integer
#  nb_click_url     :integer
#

require 'spec_helper'

describe Webapp do
  
  before(:each) do
    @webapp = FactoryGirl.create(:webapp)
    @tag = Tag.new(:name=>"test")
  end


  # Method top_trend
  describe "Test method top trend" do
    it "should exist" do
      Webapp.should respond_to(:top_trend)
    end

    it "should return 3 top click_detail website" do
      @webapp1 = FactoryGirl.build(:webapp)
      @webapp1.nb_click_detail = 53 ;
      @webapp1.save
      @webapp2 = FactoryGirl.build(:webapp)
      @webapp2.nb_click_detail = 52 ;
      @webapp2.save
      @webapp3 = FactoryGirl.build(:webapp)
      @webapp3.nb_click_detail = 51 ;
      @webapp3.save

      webapps = Webapp.top_trend
      webapps.should have_exactly(3).items
      webapps.should include(@webapp1,@webapp2,@webapp3)
      webapps.should_not include(@webapp)

    end
  end

  # Method top_recent
  describe "Test method top recent" do
    it "should exist" do
      Webapp.should respond_to(:top_recent)
    end

    it "should return 3 most recents website" do
      @webapp1 = FactoryGirl.create(:webapp)
      @webapp2 = FactoryGirl.create(:webapp)
      @webapp3 = FactoryGirl.create(:webapp)

      webapps = Webapp.top_recent
      webapps.should have_exactly(3).items
      webapps.should include(@webapp1,@webapp2,@webapp3)
      webapps.should_not include(@webapp)

    end
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

    it "should be exist method 'uniform_url'" do
      FactoryGirl.build(:webapp).should respond_to(:uniform_url)
    end
    
    it "should uniform correctly an URL" do
      
      test = FactoryGirl.build(:webapp)
      ## Change
     
      test.url = "lemonde.fr"
      test.uniform_url.should eql("http://www.lemonde.fr")
      test.url = "www.lemonde.fr"
      test.uniform_url.should eql("http://www.lemonde.fr")
      test.url = "http://lemonde.fr"
      test.uniform_url.should eql("http://www.lemonde.fr")
      test.url = "https://lemonde.fr"
      test.uniform_url.should eql("https://www.lemonde.fr")

      ## No change
      test.url = "https://www.lemonde.fr"
      test.uniform_url.should eql("https://www.lemonde.fr")
      test.url = "http://www.lemonde.fr"
      test.uniform_url.should eql("http://www.lemonde.fr")
    end

  end

  describe "method incremental nb_click" do
    it "'increment_nb_click' should exist" do
      @webapp.should respond_to(:increment_nb_click)
    end

    it "should increment 1 attribute nb_click_detail" do
      ## webapp has nb_click_detail init at 3
      old_value = @webapp.nb_click_detail
      @webapp.increment_nb_click(:element => "detail")
      @webapp.nb_click_detail.should eql(old_value+1)
    end

     it "should increment 1 attribute nb_click_preview" do
      ## webapp has nb_click_detail init at 3
      old_value = @webapp.nb_click_preview
      @webapp.increment_nb_click(:element => "detail")
      @webapp.nb_click_preview.should eql(old_value+1)
    end

     it "should increment 1 attribute nb_click_url" do
      ## webapp has nb_click_detail init at 3
      old_value = @webapp.nb_click_url
      @webapp.increment_nb_click(:element => "url")
      @webapp.nb_click_url.should eql(old_value+1)
    end
    
  end
end