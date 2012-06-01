class FacebookPostsController < ApplicationController
  def show
    @facebook_post = FacebookPost.find(params[:id])
  end
end
