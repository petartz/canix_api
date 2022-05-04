require "rails_helper"

RSpec.describe Api::PostsController, type: :controller do
  describe "GET#index" do
    it "should return a list of all the gifs" do

      get :index, params: {tags:""}
      returned_json = JSON.parse(response.body)

      expect(response.status).to eq 200

    end
  end
end