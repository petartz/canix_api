class HatchwaysBlogPostClient
  def initialize
  end

  # one method that makes a request to the posts endpoint
  def self.retrieve_posts(tags)
    finalArray = []
    tags.each do |tag|
      response = RestClient.get "https://api.hatchways.io/assessment/blog/posts?tag=#{tag}"
      jsonData = JSON.parse(response.body)["posts"]
      finalArray = [*finalArray, *jsonData]
    end
    return finalArray
  end

end