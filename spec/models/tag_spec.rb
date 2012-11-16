# == Schema Information
#
# Table name: tags
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Tag do
  
  before(:each) do
    @tag = Tag.new({:name => "test"})
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
      @webapp.add_tag(@tag)
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

  describe "scope most_used" do
    it "shall have a method called webApps" do
      Tag.should respond_to(:most_used)
    end

    it "shall return n tags most used" do
      @w1 = FactoryGirl.create(:webapp)
      @w2 = FactoryGirl.create(:webapp)
      @w3 = FactoryGirl.create(:webapp)
      @w1.add_tag("test1")
      @w1.add_tag("test2")
      @w2.add_tag("test1")
      @w2.add_tag("test2")
      @w3.add_tag("test1")
      @w3.add_tag("test3")

      assert Tag.most_used(2)[0].name == "test1"
      #assert Tag.most_used(2)[0].tagAppRelations[0].coeff == 4
      assert Tag.most_used(2)[1].name == "test2"
      #assert Tag.most_used(2)[1].tagAppRelations[0].coeff == 2
    end
  end

  describe "method addTags" do
    pending "we have to wrtie this test"
  end

  
end
