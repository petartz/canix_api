module Api
  class Api::PostsController < ApplicationController
    def index

      puts(params)
      #Step 1: Get parameters to check for existence later
      if params[:tags]
        tags = params[:tags].gsub(/[!@#$%^&*()-=_+|;':".<>?']/, '').delete("[]").split(",")
      end
      sort = params[:sortBy]
      direction = params[:direction]

      #Step 2: Set up acceptable inputs for optional parameters
      sortArray = ['id', 'reads', 'likes', 'popularity']
      directionArray = ["asc", "desc"]


      #Step 3: Create a master list of posts from consecutive API calls
      ######## in JavaScript this could be done in parallel/async with Promise.All()
      ######## finalArray is composed of only Unique values

      finalArray = []
      if tags
        tags.each do |tag|
          @response = RestClient.get "https://api.hatchways.io/assessment/blog/posts?tag=#{tag}"
          jsonData = JSON.parse(@response.body)["posts"]
          finalArray = [*finalArray, *jsonData]
        end
      end
      finalArray = finalArray.uniq

      # print("lalala #{tags}")

      #Step 4: Determine API output
      ######## Case 1: No Tags --> 400 Tags
      ######## Case 2: Valid tags, No other params --> 200 default id asc
      ######## Case 3: Valid tags, Invalid sortBy OR Invalid Direction --> 400 sortBy
      ######## Case 4: Valid tags, Valid sortBy Param, No Direction Param --> 200 default to asc + variable sortBy
      ######## Case 5: Valid tags, Valid sortBy/default to id, Valid Direction --> 200 deafult id + variable Direction
      ######## Case 6: Param String Invalid

      if !tags || tags.length == 0
        return render json: { status: 400, "error": "Tags parameter is required" }
      elsif !sort && !direction
          sorted = finalArray.sort_by{ |hash| hash["id"]}
        return render json: { status: 200, posts:sorted}
      elsif (sort && !(sortArray.include? sort)) || (direction && !(directionArray.include? direction))
        return render json: { status:400, "error": "sortBy parameter is invalid"}
      elsif (sortArray.include? sort) && !direction
        sorted = finalArray.sort_by{ |hash| hash[sort]}
        # sorted.each{ |hash| puts hash[sort]}
        return render json: { status:200, message: "SUCCESS", posts: sorted }
      elsif (directionArray.include? direction)
        if (!sort)
          sort = "id"
        end
        if (direction == "desc")
          sorted = finalArray.sort_by{ |hash| hash[sort] }.reverse!
          # sorted.each{ |hash| puts hash[sort]}
          return render json: {status:200, message: "SUCCESS", posts: sorted }
        else
          sorted = finalArray.sort_by{ |hash| hash[sort] }
          return render json: { status:200, message: "SUCCESS", posts: sorted }
        end
      end

      render json: {status:400, message: "Your query parameters are wrong"}
    end
  end
end


# Questions for Nick:
# How can I default the /api/post route to not error out without parameters
# Parallel GET requests?
# How do you even write routes in ruby?


#Tests questions
# Test that router issues GET request to the "index/show? of posts-controller"
# Test essentially all parameter variations
# no tags === 400
# tags not in the array = 200 but empty array
# tags with wrong sort = 400 sort error
# tags with correct sort = 200
# tags with correct sort wrong direction = 400
# tags with correct sort correct direction = 200
#