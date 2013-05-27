require 'spec_helper'

describe CategoriesController do

	before(:each) do
    (0..2).each do
      FactoryGirl.create(:webapp, :with_comments)
    end
  end

  ## Test INDEX method
  describe "GET index" do
   it "returns http success" do
     get :index
     response.should be_success
   end

   it "should return a valid json" do
   	get :index
   	expect { parse_json(response.body) }.should_not raise_error(MultiJson::DecodeError)
   end

   it "should return categories" do
   	get :index
   	response.body.should have_json_size(Category.count)
   end

   it "should have integer id" do
   	get :index
    response.body.should have_json_path("0/id")
    response.body.should have_json_type(Integer).at_path("0/id")
    parse_json(response.body, "0/id").should == Category.first.id
   end

   it "should have string name" do
   	get :index
    response.body.should have_json_path("0/name")
    response.body.should have_json_type(String).at_path("0/name")
    parse_json(response.body, "0/name").should == Category.first.name
   end

   it "should have description field" do
   	get :index
    response.body.should have_json_path("0/description")
    parse_json(response.body, "0/description").should == Category.first.description
   end
  end

  ## Test SHOW method
  describe "GET show" do
   it "returns http success" do
   	get :show, id: Category.first
   	response.should be_success
   end

   it "should return a valid json" do
   	get :show, id: Category.first
   	expect { parse_json(response.body) }.should_not raise_error(MultiJson::DecodeError)
   end

   it "should have integer id" do
   	get :show, id: Category.first
    response.body.should have_json_path("id")
    response.body.should have_json_type(Integer).at_path("id")
    parse_json(response.body, "id").should == Category.first.id
   end

   it "should have string name" do
   	get :show, id: Category.first
    response.body.should have_json_path("name")
    response.body.should have_json_type(String).at_path("name")
    parse_json(response.body, "name").should == Category.first.name
   end

   it "should have description field" do
   	get :show, id: Category.first
    response.body.should have_json_path("description")
    parse_json(response.body, "description").should == Category.first.description
   end

  end

end
