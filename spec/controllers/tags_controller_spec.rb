require 'spec_helper'

describe TagsController do
  render_views

  before(:each) do
    (0..2).each do
      FactoryGirl.create(:tag)
    end
  end

  describe "GET index" do
    it "should return a success http" do
      get :index
      response.should be_success
    end

    it "should return a valid json" do
      get :index
      expect { parse_json(response.body) }.should_not raise_error(MultiJson::DecodeError)
    end

    it "should return 3 tags" do
      get :index
      response.body.should have_json_size(Tag.count)
    end

    it "should have integer id" do
      get :index
      response.body.should have_json_path("0/id")
      response.body.should have_json_type(Integer).at_path("0/id")
      parse_json(response.body, "0/id").should == Tag.first.id
    end

    it "should have string name" do
      get :index
      response.body.should have_json_path("0/name")
      response.body.should have_json_type(String).at_path("0/name")
      parse_json(response.body, "0/name").should == Tag.first.name
    end
  end

  describe "GET show" do
    it "should return a success http" do
      get :show, id: Tag.first
      puts response.body
      response.should be_success
    end

    it "should return a valid json" do
      get :show, id: Tag.first
      expect { parse_json(response.body) }.should_not raise_error(MultiJson::DecodeError)
    end

    it "should have integer id" do
      get :show, id: Tag.first
      response.body.should have_json_path("id")
      response.body.should have_json_type(Integer).at_path("id")
      parse_json(response.body, "id").should == Tag.first.id
    end

    it "should have string name" do
      get :show, id: Tag.first
      response.body.should have_json_path("name")
      response.body.should have_json_type(String).at_path("name")
      parse_json(response.body, "name").should == Tag.first.name
    end
  end

  ## Test NEW method
  # describe "GET 'new'" do
  #   it "returns http success" do
  #      @user = FactoryGirl.create(:user)
  #   sign_in @user
  #     get 'new'
  #     response.should be_success
  #   end
  # end

  ## Test ASSOCIATED method
  # describe "GET 'associated'" do
  #   it "method associated shall exist" do
  #      @user = FactoryGirl.create(:user)
  #   sign_in @user
  #     tag = FactoryGirl.create(:tag)
  #     get 'associated', :id => tag.id, :format => "json"
  #     response.should be_success
  #   end
  # end

end
