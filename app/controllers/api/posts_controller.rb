module Api
  class Api::PostsController < ApplicationController
    def index
      tags = params[:tags]
      sort = params[:sortBy]
      direction = params[:direction]
      sortArray = ['id', 'reads', 'likes', 'popularity']
      directionArray = ["asc", "desc"]

      puts(direction)

      if tags
        tags = tags.gsub(",", "&")
        @response = RestClient.get "https://api.hatchways.io/assessment/blog/posts?tag=#{tags}"
        jsonData = JSON.parse(@response.body)["posts"]
      end


      if !tags
        return render json: { status: 400, "error": "Tags parameter is required" }
      elsif tags && !sort && !direction
        return render json: { status: 200, data:jsonData}
      elsif sort && !(sortArray.include? sort)
        return render json: { status:400, "error": "sortBy parameter is invalid"}
      elsif (sortArray.include? sort) && !direction
        sorted = jsonData.sort_by{ |hash| hash[sort]}
        # sorted.each{ |hash| puts hash[sort]}
        return render json: { status:200, message: "SUCCESS", data: sorted }
      elsif direction && !(directionArray.include? direction)
        return render json: { status:400, "error": "sortBy parameter is invalid"}
      elsif (directionArray.include? direction)
        puts("YELLLOOOOO")
        if (direction == "desc")
          sorted = jsonData.sort_by{ |hash| hash[sort] }.reverse!
          sorted.each{ |hash| puts hash[sort]}
          return render json: {status:200, message: "SUCCESS", data: sorted }
        else
          sorted = jsonData.sort_by{ |hash| hash[sort] }
          return render json: { status:200, message: "SUCCESS", data: sorted }
        end
      end


      render json: {status:400, message: "Your query parameters are wrong"}
    end
  end
end