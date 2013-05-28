require 'spec_helper'

describe UsersController do
  render_views

  before(:each) do
    (0..2).each do
      FactoryGirl.create(:user)
    end
    FactoryGirl.create(:admin_user)
  end

  ## Test INDEX method
  describe "GET index" do
    it "should return a success http" do
      get :index
      response.should be_success
    end

    it "should return a valid json" do
      get :index
      expect { parse_json(response.body) }.should_not raise_error(MultiJson::DecodeError)
    end

    it "should return 3 users" do
      get :index
      response.body.should have_json_size(User.count)
    end

    it "should have integer id" do
      get :index
      response.body.should have_json_path("0/id")
      response.body.should have_json_type(Integer).at_path("0/id")
      parse_json(response.body, "0/id").should == User.first.id
    end

    it "should have string email" do
      get :index
      response.body.should have_json_path("0/email")
      response.body.should have_json_type(String).at_path("0/email")
      parse_json(response.body, "0/email").should == User.first.email
    end

    it "should not be admin" do
      get :index
      response.body.should have_json_path("0/admin")
      parse_json(response.body, "0/admin").should == User.first.admin
    end

    it "should be admin" do
      get :index
      response.body.should have_json_path("3/admin")
      parse_json(response.body, "3/admin").should == User.last.admin
    end

  end

  ## Test SHOW method
  describe "GET show" do
    context 'when logged out' do
      it "should return 401 code" do
        get :show, id: User.first
        response.response_code.should == 401
      end

      it "should not return user id" do
        get :show, id: User.first
        response.body.should_not have_json_path("id")
      end

      it "should not return user email" do
        get :show, id: User.first
        response.body.should_not have_json_path("email")
      end
    end

    context 'when logged in as admin' do
      login_admin

      it "should return a success http" do
        get :show, id: User.first
        response.should be_success
      end

      it "should return a valid json" do
        get :show, id: User.first
        expect { parse_json(response.body) }.should_not raise_error(MultiJson::DecodeError)
      end

      it "should have integer id" do
        get :show, id: User.first
        response.body.should have_json_path("id")
        response.body.should have_json_type(Integer).at_path("id")
        parse_json(response.body, "id").should == User.first.id
      end

      it "should have string email" do
        get :show, id: User.first
        response.body.should have_json_path("email")
        response.body.should have_json_type(String).at_path("email")
        parse_json(response.body, "email").should == User.first.email
      end

      it "should have comments list" do
        get :show, id: User.first
        response.body.should have_json_path("comments")
      end

      it "should have webapps list" do
        get :show, id: User.first
        response.body.should have_json_path("webapps")
      end

      it "should have bookmarks list" do
        get :show, id: User.first
        response.body.should have_json_path("bookmarks")
      end

    end


    context 'when logged in as user' do
      login_user
      it "should not show another user" do
        get :show, id: User.last
        response.response_code.should == 401
      end
    end

    
  end

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