require 'rails_helper'

RSpec.describe OauthController, :type => :controller do

  describe "GET 'InstagramConnect'" do
    it "returns http success" do
      get 'InstagramConnect'
      expect(response).to be_success
    end
  end

  describe "GET 'InstagramCallback'" do
    it "returns http success" do
      get 'InstagramCallback'
      expect(response).to be_success
    end
  end

end
