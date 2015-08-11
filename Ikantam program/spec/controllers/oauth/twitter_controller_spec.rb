require 'rails_helper'

RSpec.describe Oauth::TwitterController, :type => :controller do

  describe "GET connect" do
    it "returns http success" do
      get :connect
      expect(response).to be_success
    end
  end

  describe "GET callback" do
    it "returns http success" do
      get :callback
      expect(response).to be_success
    end
  end

end
