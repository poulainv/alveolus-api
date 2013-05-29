require 'spec_helper'

describe CommentsController do
  render_views

  before(:each) do
    (0..2).each do
      FactoryGirl.create(:webapp, :with_comments)
    end
  end

  ## Test INDEX method
  describe "GET index" do

  	## webapp_id & user_id provided
  	context "when webapp_id and user_id provided" do
	    it "should return a success http" do
	      get :index, webapp_id: Webapp.first, user_id: User.first
	      response.should be_success
	    end

	    it "should return a valid json" do
	      get :index, webapp_id: Webapp.first, user_id: User.first
	      expect { parse_json(response.body) }.should_not raise_error(MultiJson::DecodeError)
	    end

	    it "should have integer id" do
	      get :index, webapp_id: Webapp.first, user_id: User.first
	      response.body.should have_json_path("id")
	      response.body.should have_json_type(Integer).at_path("id")
	    end

	    it "should have string body" do
	      get :index, webapp_id: Webapp.first, user_id: User.first
	      response.body.should have_json_path("body")
	      response.body.should have_json_type(String).at_path("body")
	    end

	    it "should have integer rating" do
	      get :index, webapp_id: Webapp.first, user_id: User.first
	      response.body.should have_json_path("rating")
	      response.body.should have_json_type(Integer).at_path("rating")
	    end

	    it "should have user" do
	      get :index, webapp_id: Webapp.first, user_id: User.first
	      response.body.should have_json_path("user")
	    end
	  end

	  ## webapp_id provided
	  context "when webapp_id provided" do
	  	it "should return a success http" do
	      get :index, webapp_id: Webapp.first
	      response.should be_success
	    end

	    it "should return a valid json" do
	      get :index, webapp_id: Webapp.first
	      expect { parse_json(response.body) }.should_not raise_error(MultiJson::DecodeError)
	    end

	    it "should return 2 comments" do
      	get :index, webapp_id: Webapp.first
      	response.body.should have_json_size(Webapp.first.comments.count)
    	end

    	it "should have integer id" do
	      get :index, webapp_id: Webapp.first
	      response.body.should have_json_path("0/id")
	      response.body.should have_json_type(Integer).at_path("0/id")
	    end

	    it "should have string body" do
	      get :index, webapp_id: Webapp.first
	      response.body.should have_json_path("0/body")
	      response.body.should have_json_type(String).at_path("0/body")
	    end

	    it "should have integer rating" do
	      get :index, webapp_id: Webapp.first
	      response.body.should have_json_path("0/rating")
	      response.body.should have_json_type(Integer).at_path("0/rating")
	    end

	    it "should have user" do
	      get :index, webapp_id: Webapp.first
	      response.body.should have_json_path("0/user")
	    end
	  end

	  ## user_id provided
	  context "when user_id provided" do
	  	it "should return a success http" do
	      get :index, user_id: User.first
	      response.should be_success
	    end

	    it "should return a valid json" do
	      get :index, user_id: User.first
	      expect { parse_json(response.body) }.should_not raise_error(MultiJson::DecodeError)
	    end

	    it "should return user comments" do
      	get :index, user_id: User.first
      	response.body.should have_json_size(User.first.comments.count)
    	end

    	it "should have integer id" do
	      get :index, user_id: User.first
	      response.body.should have_json_path("0/id")
	      response.body.should have_json_type(Integer).at_path("0/id")
	    end

	    it "should have string body" do
	      get :index, user_id: User.first
	      response.body.should have_json_path("0/body")
	      response.body.should have_json_type(String).at_path("0/body")
	    end

	    it "should have integer rating" do
	      get :index, user_id: User.first
	      response.body.should have_json_path("0/rating")
	      response.body.should have_json_type(Integer).at_path("0/rating")
	    end

	    it "should have user" do
	      get :index, user_id: User.first
	      response.body.should have_json_path("0/user")
	    end
	  end

  end



end