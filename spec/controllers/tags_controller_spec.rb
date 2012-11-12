require 'spec_helper'

describe TagsController do


  ## Test NEW method
  describe "GET 'new'" do
    it "returns http success" do
      get 'new'
      response.should be_success
    end
  end

  ## Test ASSOCIATED method
  describe "GET 'associated'" do
    it "method associated shall exist" do
      tag = FactoryGirl.create(:tag)
      get 'associated', :id => tag.id, :format => "json"
      response.should be_success
    end
  end

end
