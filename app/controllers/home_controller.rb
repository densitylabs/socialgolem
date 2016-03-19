class HomeController < ApplicationController
  def index
  end

  def unfriendly_users
    @users = connector.unfriendly_users
  end

  def unfollow_users
    @users = connector.unfollow_users(params[:users_ids].split(','))
  end

  def users_im_unfriendly_with
    @users = connector.users_im_unfriendly_with
  end

  def follow_users
    @users = connector.follow_users(params[:users_ids].split(','))
  end

  def logout
    reset_session
    redirect_to root_path
  end

  private

  def connector
    @connector ||= TwitterUserConnector.new(User.find(session[:user_id]))
  end
end
