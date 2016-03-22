class TwitterUsersController < ApplicationController
  def show
    @followers = connector.followers_info_for(params[:id])
    @friends = connector.friends_info_for(params[:id])
  end
end
