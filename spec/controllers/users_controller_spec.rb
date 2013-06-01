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

    it "should not have email" do
      get :index
      response.body.should_not have_json_path("0/email")
    end

  end

  ## Test SHOW method
  describe "GET show" do

    ## NOT LOGGED IN
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

    ## LOGGED IN AS ADMIN
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

    ## LOGGED IN AS USER
    context 'when logged in as user' do
      login_user

      it "should not show another user" do
        get :show, id: User.first
        response.response_code.should == 401
      end

      # User.last is logged user
      it "should return a success http" do
        get :show, id: User.last
        response.should be_success
      end

      it "should return a valid json" do
        get :show, id: User.last
        expect { parse_json(response.body) }.should_not raise_error(MultiJson::DecodeError)
      end

      it "should have integer id" do
        get :show, id: User.last
        response.body.should have_json_path("id")
        response.body.should have_json_type(Integer).at_path("id")
        parse_json(response.body, "id").should == User.last.id
      end

      it "should have string email" do
        get :show, id: User.last
        response.body.should have_json_path("email")
        response.body.should have_json_type(String).at_path("email")
        parse_json(response.body, "email").should == User.last.email
      end

      it "should have comments list" do
        get :show, id: User.last
        response.body.should have_json_path("comments")
      end

      it "should have webapps list" do
        get :show, id: User.last
        response.body.should have_json_path("webapps")
      end

      it "should have bookmarks list" do
        get :show, id: User.last
        response.body.should have_json_path("bookmarks")
      end

    end

  end

  ## Test UPDATE method
  describe "GET update" do

    ## NOT LOGGED IN
    context 'when logged out' do

      it "should return 401 code" do
        put :update, id: User.first
        response.response_code.should == 401
      end

      it "should return a valid json" do
        put :update, id: User.first
        expect { parse_json(response.body) }.should_not raise_error(MultiJson::DecodeError)
      end

      it "should return authentication error" do
        put :update, id: User.first
        response.body.should have_json_path("errors")
        parse_json(response.body, "errors").should == "Authentication needed"
      end

    end

    ## LOGGED IN AS ADMIN
    context 'when logged in as admin' do
      login_admin

      ## Unvalid update
      context 'when update parameters are unvalid' do

        it "should return 422 code" do
          put :update, id: User.first, user: { email: 123 }
          response.response_code == 422
        end

        it "should return a valid json" do
          put :update, id: User.first, user: { email: 123 }
          expect { parse_json(response.body) }.should_not raise_error(MultiJson::DecodeError)
        end

        it "should have errors" do
          put :update, id: User.first, user: { email: 123 }
          response.body.should have_json_path("errors")
        end

      end

      ## Valid update
      context 'when update parameters are valid' do

        it "should return a success http" do
          put :update, id: User.first, user: { pseudo: "monpseudoquidechire" }
          response.should be_success
        end

        it "should return a valid json" do
          put :update, id: User.first, user: { pseudo: "monpseudoquidechire" }
          expect { parse_json(response.body) }.should_not raise_error(MultiJson::DecodeError)
        end

        it "should have 'monpseudoquidechire' pseudo" do
          put :update, id: User.first, user: { pseudo: "monpseudoquidechire" }
          response.body.should have_json_path("pseudo")
          response.body.should have_json_type(String).at_path("pseudo")
          parse_json(response.body, "pseudo").should == "monpseudoquidechire"
        end

        it "should have integer id" do
          put :update, id: User.first, user: { pseudo: "monpseudoquidechire" }
          response.body.should have_json_path("id")
          response.body.should have_json_type(Integer).at_path("id")
          parse_json(response.body, "id").should == User.first.id
        end

        it "should have string email" do
          put :update, id: User.first, user: { pseudo: "monpseudoquidechire" }
          response.body.should have_json_path("email")
          response.body.should have_json_type(String).at_path("email")
          parse_json(response.body, "email").should == User.first.email
        end

        it "should have comments list" do
          put :update, id: User.first, user: { pseudo: "monpseudoquidechire" }
          response.body.should have_json_path("comments")
        end

        it "should have webapps list" do
          put :update, id: User.first, user: { pseudo: "monpseudoquidechire" }
          response.body.should have_json_path("webapps")
        end

        it "should have bookmarks list" do
          put :update, id: User.first, user: { pseudo: "monpseudoquidechire" }
          response.body.should have_json_path("bookmarks")
        end

      end

    end

    ## LOGGED IN AS USER
    context 'when logged in as user' do
      login_user

      ## trying to update another user
      context 'when trying to update another user' do

        it "should return 422 code" do
          put :update, id: User.first, user: { pseudo: "monpseudoquidechire" }
          response.response_code == 422
        end

        it "should return a valid json" do
          put :update, id: User.first, user: { pseudo: "monpseudoquidechire" }
          expect { parse_json(response.body) }.should_not raise_error(MultiJson::DecodeError)
        end

        it "should have errors" do
          put :update, id: User.first, user: { pseudo: "monpseudoquidechire" }
          response.body.should have_json_path("errors")
        end

      end


      ## Unvalid update
      context 'when update parameters are unvalid' do

        it "should return 422 code" do
          put :update, id: User.last, user: { email: 123 }
          response.response_code == 422
        end

        it "should return a valid json" do
          put :update, id: User.last, user: { email: 123 }
          expect { parse_json(response.body) }.should_not raise_error(MultiJson::DecodeError)
        end

        it "should have errors" do
          put :update, id: User.last, user: { email: 123 }
          response.body.should have_json_path("errors")
        end

      end

      ## Valid update
      context 'when update parameters are valid' do

        it "should return a success http" do
          put :update, id: User.last, user: { pseudo: "monpseudoquidechire" }
          response.should be_success
        end

        it "should return a valid json" do
          put :update, id: User.last, user: { pseudo: "monpseudoquidechire" }
          expect { parse_json(response.body) }.should_not raise_error(MultiJson::DecodeError)
        end

        it "should have 'monpseudoquidechire' pseudo" do
          put :update, id: User.last, user: { pseudo: "monpseudoquidechire" }
          response.body.should have_json_path("pseudo")
          response.body.should have_json_type(String).at_path("pseudo")
          parse_json(response.body, "pseudo").should == "monpseudoquidechire"
        end

        it "should have integer id" do
          put :update, id: User.last, user: { pseudo: "monpseudoquidechire" }
          response.body.should have_json_path("id")
          response.body.should have_json_type(Integer).at_path("id")
          parse_json(response.body, "id").should == User.last.id
        end

        it "should have string email" do
          put :update, id: User.last, user: { pseudo: "monpseudoquidechire" }
          response.body.should have_json_path("email")
          response.body.should have_json_type(String).at_path("email")
          parse_json(response.body, "email").should == User.last.email
        end

        it "should have comments list" do
          put :update, id: User.last, user: { pseudo: "monpseudoquidechire" }
          response.body.should have_json_path("comments")
        end

        it "should have webapps list" do
          put :update, id: User.last, user: { pseudo: "monpseudoquidechire" }
          response.body.should have_json_path("webapps")
        end

        it "should have bookmarks list" do
          put :update, id: User.last, user: { pseudo: "monpseudoquidechire" }
          response.body.should have_json_path("bookmarks")
        end

      end

    end

  end

end