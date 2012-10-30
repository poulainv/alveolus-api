require 'spec_helper'
require 'web_apps_helper'
include WebAppsHelper

describe WebappsController do
  render_views
  
  describe "GET 'new'" do
    it "returns http success" do
      get 'new'
      response.should be_success
    end

    it "shall have a good title" do
      get 'new'
      response.should have_selector("title", :content => @title)
    end
  end



  describe "POST 'create'" do

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


  describe "index GET" do
    it "shall return a success http" do
      get 'index'
      response.should be_success
    end

    it "shall return list of webapps" do
      FactoryGirl.create(:webapp)
      FactoryGirl.create(:webapp)
      get 'index', :format => :json
      webapps = JSON.parse(@response.body)
      assert webapps.size == 2, "Webapp controller don't return a good number of webapp"

    end
  end

end
