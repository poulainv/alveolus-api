require 'spec_helper'

describe BookmarksController do
  render_views

  before(:each) do
    (0..2).each do
      FactoryGirl.create(:webapp, :with_bookmarks)
    end
  end

  describe "GET index" do

  	context "when webapp_id is provided" do

	    it "should return a success http" do
	      get :index, webapp_id: Webapp.first
	      response.should be_success
	    end

	    it "should return a valid json" do
	      get :index, webapp_id: Webapp.first
	      expect { parse_json(response.body) }.should_not raise_error(MultiJson::DecodeError)
	    end

	    it "should return 2 bookmarks" do
	      get :index, webapp_id: Webapp.first
	      response.body.should have_json_size(Webapp.first.bookmarks.count)
	    end

	    it "should have integer id" do
	      get :index, webapp_id: Webapp.first
	      response.body.should have_json_path("0/id")
	      response.body.should have_json_type(Integer).at_path("0/id")
	      parse_json(response.body, "0/id").should == Webapp.first.bookmarks.first.id
	    end

	    it "should have integer user_id" do
	      get :index, webapp_id: Webapp.first
	      response.body.should have_json_path("0/user_id")
	      response.body.should have_json_type(Integer).at_path("0/user_id")
	      parse_json(response.body, "0/user_id").should == Webapp.first.bookmarks.first.user_id
	    end

	    it "should have integer webapp_id" do
	      get :index, webapp_id: Webapp.first
	      response.body.should have_json_path("0/webapp_id")
	      response.body.should have_json_type(Integer).at_path("0/webapp_id")
	      parse_json(response.body, "0/webapp_id").should == Webapp.first.bookmarks.first.webapp_id
	    end

	  end

	  context "when user_id is provided" do

	  	it "should return a success http" do
	      get :index, user_id: User.first
	      response.should be_success
	    end

	    it "should return a valid json" do
	      get :index, user_id: User.first
	      expect { parse_json(response.body) }.should_not raise_error(MultiJson::DecodeError)
	    end

	    it "should return users bookmarks" do
	      get :index, user_id: User.first
	      response.body.should have_json_size(User.first.bookmarks.count)
	    end

	    it "should have integer id" do
	      get :index, user_id: User.first
	      response.body.should have_json_path("0/id")
	      response.body.should have_json_type(Integer).at_path("0/id")
	      parse_json(response.body, "0/id").should == User.first.bookmarks.first.id
	    end

	    it "should have integer user_id" do
	      get :index, user_id: User.first
	      response.body.should have_json_path("0/user_id")
	      response.body.should have_json_type(Integer).at_path("0/user_id")
	      parse_json(response.body, "0/user_id").should == User.first.bookmarks.first.user_id
	    end

	    it "should have integer webapp_id" do
	      get :index, user_id: User.first
	      response.body.should have_json_path("0/webapp_id")
	      response.body.should have_json_type(Integer).at_path("0/webapp_id")
	      parse_json(response.body, "0/webapp_id").should == User.first.bookmarks.first.webapp_id
	    end

	  end

	end

	describe "POST create" do

		## NOT LOGGED IN
    context 'when logged out' do
    	it "should return 401 code" do
        post :create, webapp_id: Webapp.first
        response.response_code.should == 401
      end

      it "should return a valid json" do
        post :create, webapp_id: Webapp.first
        expect { parse_json(response.body) }.should_not raise_error(MultiJson::DecodeError)
      end

      it "should display authentication error" do
        post :create, webapp_id: Webapp.first
        response.body.should have_json_path("errors")
        response.body.should have_json_type(String).at_path("errors")
        parse_json(response.body, "errors").should == "Authentication needed"
      end
    end

    ## LOGGED IN AS USER
    context 'when logged in as user' do
      login_user

      it "should return a success http" do
        post :create, webapp_id: Webapp.first
        response.should be_success
      end

      it "should return a valid json" do
        post :create, webapp_id: Webapp.first
        expect { parse_json(response.body) }.should_not raise_error(MultiJson::DecodeError)
      end

      it "should display success message" do
        post :create, webapp_id: Webapp.first
        response.body.should have_json_path("success")
        response.body.should have_json_type(String).at_path("success")
        parse_json(response.body, "success").should == "Alveolus bookmarked"
      end
    end

	end

	describe "DELETE destroy" do

		## NOT LOGGED IN
    context 'when logged out' do
    	it "should return 401 code" do
        delete :destroy, webapp_id: Webapp.first
        response.response_code.should == 401
      end
    end

    ## LOGGED IN AS USER
    context 'when logged in as user' do
      login_user

      it "should return a success http" do
	      delete :destroy, webapp_id: Webapp.first
	      response.should be_success
	    end
    end

	end
end