require_relative "../../models/hatch_ways_blog_post_client"
require_relative "../../models/hatch_ways_blog_post_response_manager"
module Api
  class Api::PostsController < ApplicationController

    def index
      # query_params = request.query_parameters
      if params[:tags]
        tags = sanitize_tags(params[:tags])
      end
      sort = params[:sortBy]
      direction = params[:direction]
      posts = []
      if tags
        posts = HatchwaysBlogPostClient.retrieve_posts(tags).uniq
      end

      response_manager = HawtchWaysBlogPostResponseManager.new(tags, sort, direction, posts)
      response_body = response_manager.generate_response
      if response_body[:error]
        render json: response_body, status: 400
      else
        render json: response_body, status: 200
      end
    end

    private
      def sanitize_tags(tags)
        return tags.gsub(/[!@#$%^&*()-=_+|;':".<>?']/, '').delete("[]").split(",")
      end

      def post_params
        params.permit(:tags, :direction, :sortBy)
      end
  end
end
