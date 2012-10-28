require 'spec_helper'

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


end
