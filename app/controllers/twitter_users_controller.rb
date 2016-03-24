class TwitterUsersController < ApplicationController
  def show
    LoadRelatedTwitterUsersJob.perform_later(session[:user_id], params[:id],
                                           'followers')
  end
end
