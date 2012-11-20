require 'spec_helper'


describe WebappsController do
  
  ## for testing we add 3 webapps in test data base
  before(:each) do
    Webapp.stub(:recent).and_return(Webapp.new)
    Webapp.stub(:trend).and_return(Webapp.new)

    (0..2).each do
      FactoryGirl.create(:webapp)
    end
  end

  ## Test INDEX method
  describe "index GET" do

    it "shall return a success http" do
      get 'index'
      response.should be_success
    end

    it "shall call Webapp validated method" do

      Webapp.should_receive(:validated)
      get 'index'
    end

    it "shall return list of webapps" do
      get 'index', :format => :json
      webapps = JSON.parse(@response.body)
      webapps.size.should == 3
    end
  end

  ## Test NEW method
  describe "GET 'new'" do 
    it "returns http success" do
      get 'new'
      response.should be_success
    end

    it "shall call Webapp.new" do
      Webapp.should_receive(:new)
      get 'new'
    end

    ## In order to find selector "title" we ask to render views 
    context "with render_views" do
      render_views
      it "shall have a good title" do
        get 'new'
        response.should have_selector("h2", :content => @subtitle)
      end
    end
  end


  ## Test CREATE method
  describe "POST 'create'" do

    ## Test the fail
    describe "fail" do
      before(:each) do
        @attr = { :title => "", :caption => "", :url => "",
          :description => "" }
      end

      it "ne devrait pas creer d'utilisateur" do
        lambda do
          post :create, :webapp => @attr
        end.should_not change(Webapp, :count)
      end

      it "devrait rendre la page 'new'" do
        post :create, :webapp => @attr
        response.should render_template('new')
      end
    end

    ## Test the success
    describe "success" do
      before(:each) do
        @attr = FactoryGirl.attributes_for(:webapp)
      end

      it "shall be create a webapp" do
        lambda do
          post :create, :webapp => @attr
        end.should change(Webapp, :count).by(1)
      end

      it "shall be redirect to accueil" do
        post :create, :webapp => @attr
        response.should redirect_to(accueil_path)
      end
    end  
  end

  ## Test method tops
  describe "method webapps top recent" do
    it "should call 'top_recent' of Model" do
      Webapp.should_receive(:trend).with(5)
      get :index
    end
  end
  describe "method webapps top comment" do
    it "should call 'top_comment' of Model" do
      Webapp.should_receive(:most_commented).with(5)
      get :index
    end
  end
  describe "method webapps top trend" do
    it "should call 'top_trend' of Model" do
      Webapp.should_receive(:best_rated).with(5)
      get :index
    end
  end
end
