require 'rails_helper'

RSpec.describe UsersController, :type => :controller do

  describe "GET validate" do
    it "returns http success" do
      get :validate
      expect(response).to be_success
    end
  end

end
