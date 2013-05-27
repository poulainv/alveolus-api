require 'spec_helper'


describe WebappsController do
  render_views
  
  ## for testing we add 3 webapps in test data base
  before(:each) do
    #Webapp.stub(:recent).and_return(Webapp.new)
    #Webapp.stub(:trend).and_return(Webapp.new)

    FactoryGirl.create(:category)
    (0..2).each do
      FactoryGirl.create(:webapp, :with_comments)
    end
  end

  ## Test INDEX method
  describe "GET index" do
    it "should return a success http" do
      get 'index'
      response.should be_success
    end

    it "should return a valid json" do
      get 'index'
      expect { parse_json(response.body) }.should_not raise_error(MultiJson::DecodeError)
    end

    it "should return 3 webapps" do
      get 'index'
      response.body.should have_json_size(3)
    end

    it "should have integer id" do
      get 'index'
      response.body.should have_json_path("0/id")
      response.body.should have_json_type(Integer).at_path("0/id")
      parse_json(response.body, "0/id").should == Webapp.first.id
    end

    it "should have string title 'Babyloan'" do
      get 'index'
      response.body.should have_json_path("0/title")
      response.body.should have_json_type(String).at_path("0/title")
      parse_json(response.body, "0/title").should == Webapp.first.title
    end

    it "should have string caption" do
      get 'index'
      response.body.should have_json_path("0/caption")
      response.body.should have_json_type(String).at_path("0/caption")
      parse_json(response.body, "0/caption").should == Webapp.first.caption
    end

    it "should have string description" do
      get 'index'
      response.body.should have_json_path("0/description")
      response.body.should have_json_type(String).at_path("0/description")
      parse_json(response.body, "0/description").should == Webapp.first.description
    end

    it "should have integer category id" do
      get 'index'
      response.body.should have_json_path("0/category_id")
      response.body.should have_json_type(Integer).at_path("0/category_id")
      parse_json(response.body, "0/category_id").should == Webapp.first.category_id
    end

    it "should have integer nb_click_preview" do
      get 'index'
      response.body.should have_json_path("0/nb_click_preview")
      response.body.should have_json_type(Integer).at_path("0/nb_click_preview")
      parse_json(response.body, "0/nb_click_preview").should == Webapp.first.nb_click_preview
    end

    it "should have tags list" do
      get 'index'
      response.body.should have_json_path("0/tags")
    end

    it "should have comments list" do
      get 'index'
      response.body.should have_json_path("0/comments")
    end

    it "should have category" do
      get 'index'
      response.body.should have_json_path("0/category")
    end
  end

  ## Test SHOW method
  describe "GET show" do
    it "should return a success http" do
      get :show, id: Webapp.first
      response.should be_success
    end

    it "should return a valid json" do
      get :show, id: Webapp.first
      expect { parse_json(response.body) }.should_not raise_error(MultiJson::DecodeError)
    end

    it "should have integer id" do
      get :show, id: Webapp.first
      response.body.should have_json_path("id")
      response.body.should have_json_type(Integer).at_path("id")
       parse_json(response.body, "id").should == Webapp.first.id
    end

    it "should have string title 'Babyloan'" do
      get :show, id: Webapp.first
      response.body.should have_json_path("title")
      response.body.should have_json_type(String).at_path("title")
      parse_json(response.body, "title").should == Webapp.first.title
    end

    it "should have string caption" do
      get :show, id: Webapp.first
      response.body.should have_json_path("caption")
      response.body.should have_json_type(String).at_path("caption")
      parse_json(response.body, "caption").should == Webapp.first.caption
    end

    it "should have string description" do
      get :show, id: Webapp.first
      response.body.should have_json_path("description")
      response.body.should have_json_type(String).at_path("description")
      parse_json(response.body, "description").should == Webapp.first.description
    end

    it "should have integer category id" do
      get :show, id: Webapp.first
      response.body.should have_json_path("category_id")
      response.body.should have_json_type(Integer).at_path("category_id")
      parse_json(response.body, "category_id").should == Webapp.first.category_id
    end

    it "should have integer nb_click_preview" do
      get :show, id: Webapp.first
      response.body.should have_json_path("nb_click_preview")
      response.body.should have_json_type(Integer).at_path("nb_click_preview")
      parse_json(response.body, "nb_click_preview").should == Webapp.first.nb_click_preview
    end

    it "should have tags list" do
      get :show, id: Webapp.first
      response.body.should have_json_path("tags")
    end

    it "should have comments list" do
      get :show, id: Webapp.first
      response.body.should have_json_path("comments")
    end

    it "should have category" do
      get :show, id: Webapp.first
      response.body.should have_json_path("category")
    end
  end

  # Test NEW method
  describe "GET 'edit'" do

    context 'when logged out' do
      it "should return 401 code" do
        get :edit, id: Webapp.first
        response.response_code.should == 401
      end
    end
    
    context 'when logged in' do
      login_admin
      it "returns http success" do
        get :edit, id: Webapp.first
        response.should be_success
      end
    end
  end

  ## Test NEW method
  # describe "GET 'new'" do 
  #   it "returns http success" do
  #     get 'new'
  #     response.should be_success
  #   end

  #   it "shall call Webapp.new" do
  #     Webapp.should_receive(:new)
  #     get 'new'
  #   end

  #   ## In order to find selector "title" we ask to render views 
  #   context "with render_views" do
  #     render_views
  #     it "shall have a good title" do
  #       get 'new'
  #       response.should have_selector("h2", :content => @subtitle)
  #     end
  #   end
  # end


  ## Test CREATE method
  #describe "POST 'create'" do

    ## Test the fail
    # describe "fail" do
    #   before(:each) do
    #     @attr = { :title => "", :caption => "", :url => "",
    #       :description => "" }
    #   end

    #   it "ne devrait pas creer d'utilisateur" do
    #     lambda do
    #       post :create, :webapp => @attr
    #     end.should_not change(Webapp, :count)
    #   end

    #   it "devrait rendre la page 'new'" do
    #     post :create, :webapp => @attr
    #     response.should render_template('new')
    #   end
    # end

    ## Test the success
  #   describe "success" do
  #     before(:each) do
  #       @attr = FactoryGirl.attributes_for(:webapp)
  #     end

  #     it "shall be create a webapp" do
  #       lambda do
  #         post :create, :webapp => @attr
  #       end.should change(Webapp, :count).by(1)
  #     end

  #     it "shall be redirect to accueil" do
  #       post :create, :webapp => @attr
  #       response.should redirect_to(accueil_path)
  #     end
  #   end  
  # end

  ## Test method tops
  # describe "method webapps top recent" do
  #   it "should call 'top_recent' of Model" do
  #     Webapp.should_receive(:trend).with(5)
  #     get :index
  #   end
  # end
  # describe "method webapps top comment" do
  #   it "should call 'top_comment' of Model" do
  #     Webapp.should_receive(:most_commented).with(5)
  #     get :index
  #   end
  # end
  # describe "method webapps top trend" do
  #   it "should call 'top_trend' of Model" do
  #     Webapp.should_receive(:best_rated).with(5)
  #     get :index
  #   end
  # end

  ## Vote method
  #describe "method vote" do
#
#    it "should call add_or_update_evaluation" do
#       Webapp.should_receive(:add_or_update_evaluation)
#    end

  #end
end
