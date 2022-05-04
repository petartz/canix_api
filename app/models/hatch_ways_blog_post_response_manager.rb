class HawtchWaysBlogPostResponseManager
  SORT_OPTIONS = ['id', 'reads', 'likes', 'popularity']
  DIRECTION_OPTIONS = ["asc", "desc"]

  attr_reader :tags, :sort, :direction, :posts
  def initialize(tags, sort, direction, posts)
    @tags = tags
    @sort = sort
    @direction = direction
    @posts = posts
  end

  # one method that makes a request to the posts endpoint
  def generate_response()

    if !tags || tags.length == 0
      return {"error": "Tags parameter is required"}
    elsif !sort && !direction
        sorted = posts.sort_by{ |hash| hash["id"] }
      return {"message": "SUCCESS", "posts": sorted}
    elsif (sort && !(SORT_OPTIONS.include? sort)) || (direction && !(DIRECTION_OPTIONS.include? direction))
      return {"error": "sortBy parameter is invalid"}
    elsif (SORT_OPTIONS.include? sort) && !direction
      sorted = posts.sort_by{ |hash| hash[sort]}
      return {"message": "SUCCESS", "posts": sorted}
    elsif (DIRECTION_OPTIONS.include? direction)
      if !sort
        if (direction == "desc")
          sorted = (posts.sort_by{ |hash| hash["id"] }).reverse!
          return {"message": "SUCCESS", "posts": sorted}
        else
          sorted = posts.sort_by{ |hash| hash["id"] }
          return {"message": "SUCCESS", "posts": sorted}
        end
      else
        if (direction == "desc")
          sorted = (posts.sort_by{ |hash| hash[sort] }).reverse!
          return {"message": "SUCCESS", "posts": sorted}
        else
          sorted = posts.sort_by{ |hash| hash[sort] }
          return {"message": "SUCCESS", "posts": sorted}
        end
      end
    end
    return {"message": "Your query parameters are wrong"}
  end

end