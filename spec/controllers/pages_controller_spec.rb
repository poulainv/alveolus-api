require 'spec_helper'

describe PagesController , :type => :controller do

  describe "GET 'actualites'" do
    it "should be successful" do
      get 'actualites'
      response.should be_success
    end
  end

  describe "GET 'about'" do
    it "should be successful" do
      get 'about'
      response.should be_success
    end
  end
end