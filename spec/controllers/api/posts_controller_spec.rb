require "rails_helper"

RSpec.describe Api::PostsController, type: :controller do
  describe "GET#index" do

  # Status Testing for tags, sortBy, direction

  # given, when then

    #Tags Status Testing
    context "if only tag param is supplied" do
      it "when tag is nil, should return a 400 status with message Tags Parameter Required" do
        get :index, params: {tags: nil}
        returned_json = JSON.parse(response.body)
        expect(response.status).to eq 400
        expect(returned_json["error"]).to eq "Tags parameter is required"
      end

      it "when the tag word is not proper, should return a status 200 an empty return array for posts" do
        get :index, params: {tags: "nothing"}
        returned_json = JSON.parse(response.body)
        expect(response.status).to eq 200
        expect(returned_json["posts"].length()).to eq 0
      end

      it "when the tag word isn't proper, should return a 200 status(however posts array is empty)" do
        get :index, params: {tags: "nothing"}
        returned_json = JSON.parse(response.body)
        expect(response.status).to eq 200
      end

      it "when word tag is proper should return a non-zero length posts array" do
        get :index, params: {tags: "culture"}
        returned_json = JSON.parse(response.body)
        expect(response.status).to eq 200
        expect(returned_json["posts"].length()).not_to eq 0
      end
    end


    #SortBy Status Testing
    context "if sortBy is supplied" do
      it "when sortBy parameter is correct should return a 200 status" do
        get :index, params: {tags: "culture", sortBy:"likes"}
        returned_json = JSON.parse(response.body)
        expect(response.status).to eq 200
      end

      it "when the sortBy parameter is invalid should return a 400 status with message sortBy Parameter Invalid" do
        get :index, params: {tags: "culture", sortBy:"notCorrect"}
        returned_json = JSON.parse(response.body)
        expect(response.status).to eq 400
        expect(returned_json["error"]).to eq "sortBy parameter is invalid"
      end

      it "when sortBy parameter is correct should return a 200 status" do
        get :index, params: {tags: "culture", sortBy:"likes"}
        returned_json = JSON.parse(response.body)
        expect(response.status).to eq 200
      end
    end

      it "when the sortBy parameter is invalid should return a 400 status with message sortBy Parameter Invalid" do
        get :index, params: {tags: "culture", sortBy:"notCorrect"}
        returned_json = JSON.parse(response.body)
        expect(response.status).to eq 400
        expect(returned_json["error"]).to eq "sortBy parameter is invalid"
      end

    # Direction Status Testing
    context "if direction is supplied" do
      it "when proper direction parameter (asc) is given should return a 200 status" do
        get :index, params: {tags: "culture", sortBy:"likes", direction:"asc"}
        returned_json = JSON.parse(response.body)
        expect(response.status).to eq 200
      end
      it "when proper direction parameter (desc) is given should return a 200 status" do
        get :index, params: {tags: "culture", sortBy:"likes", direction:"desc"}
        returned_json = JSON.parse(response.body)
        expect(response.status).to eq 200
      end
    end


    it "should return a 200 status with proper direction parameter (desc)" do
      get :index, params: {tags: "culture", sortBy:"likes", direction:"desc"}
      returned_json = JSON.parse(response.body)
      expect(response.status).to eq 200
    end

    it "should return a 400 status with improper direction parameter (wrongParam)" do
      get :index, params: {tags: "culture", sortBy:"likes", direction:"wrongParam"}
      returned_json = JSON.parse(response.body)
      expect(response.status).to eq 400
      expect(returned_json["error"]).to eq "sortBy parameter is invalid"
    end


    ### Tags Parameter Testing
    context "if tag parameter is supplied" do
      it "when there are multiple tags, should return different array than with a single tag" do
        get :index, params: {tags: "culture", sortBy:"likes"}
        first_response = JSON.parse(response.body)
        get :index, params: {tags: "culture,tech", sortBy:"likes"}
        second_response = JSON.parse(response.body)
        expect(first_response).not_to match_array second_response
      end
    end


    ### sortBy Parameter Testing
    it "should return a likes count for the first element less than or equal to the second (asc order)" do
      get :index, params: {tags: "culture", sortBy:"likes"}
      returned_json = JSON.parse(response.body)
      expect(returned_json["posts"][0]["likes"]).to be <= returned_json["posts"][1]["likes"]
    end

    it "should return a id count for the first element less than or equal to the second (asc order)" do
      get :index, params: {tags: "culture", sortBy:"id"}
      returned_json = JSON.parse(response.body)
      expect(returned_json["posts"][0]["id"]).to be <= returned_json["posts"][1]["id"]
    end

    it "should return a reads count for the first element less than or equal to the second (asc order)" do
      get :index, params: {tags: "culture", sortBy:"reads"}
      returned_json = JSON.parse(response.body)
      expect(returned_json["posts"][0]["reads"]).to be <= returned_json["posts"][1]["reads"]
    end

    it "should return a popularity count for the first element less than or equal to the second (asc order)" do
      get :index, params: {tags: "culture", sortBy:"popularity"}
      returned_json = JSON.parse(response.body)
      expect(returned_json["posts"][0]["popularity"]).to be <= returned_json["posts"][1]["popularity"]
    end

    it "should auto default to id sort(asc)" do
      get :index, params: {tags: "culture"}
      returned_json = JSON.parse(response.body)
      expect(returned_json["posts"][0]["id"]).to be <= returned_json["posts"][1]["id"]
      expect(returned_json["posts"][1]["id"]).to be <= returned_json["posts"][2]["id"]
      expect(returned_json["posts"][2]["id"]).to be <= returned_json["posts"][3]["id"]
      expect(returned_json["posts"][5]["id"]).to be <= returned_json["posts"][6]["id"]
    end
    ### direction parameter testing

    it "should return a popularity count for the first element greater than or equal to the second (desc order)" do
      get :index, params: {tags: "culture", sortBy:"popularity", direction:"desc"}
      returned_json = JSON.parse(response.body)
      expect(returned_json["posts"][0]["popularity"]).to be >= returned_json["posts"][1]["popularity"]
    end

    it "should return a a popularity count for the fourth element less than or equal to the fifth (asc order)" do
      get :index, params: {tags: "culture", sortBy:"popularity", direction:"asc"}
      returned_json = JSON.parse(response.body)
      expect(returned_json["posts"][4]["popularity"]).to be <= returned_json["posts"][5]["popularity"]
    end
  end
end