class HomeController < ApplicationController
  before_action :require_authentication, except: [:landing, :logout]

  def landing
    redirect_to action: :index if authenticated_user?
  end

  def index
  end

  def unfriendly_users
    @users = connector.unfriendly_users
  end

  def unfollow_users
    activity = Activities::FriendshipBatchChange.create(
      user_id: session[:user_id],
      twitter_users_ids: params[:users_ids].split(','),
      friendship_status: :unfriend,
      status: 'started')

    FriendshipBatchChangeJob.perform_later(activity.id, session[:user_id])
    redirect_to activity_path(activity)
  end

  def users_im_unfriendly_with
    @users = connector.users_im_unfriendly_with
  end

  def follow_users
    activity = Activities::FriendshipBatchChange.create(
      user_id: session[:user_id],
      twitter_users_ids: params[:users_ids].split(','),
      friendship_status: :friend,
      status: 'started')

    FriendshipBatchChangeJob.perform_later(activity.id, session[:user_id])
    redirect_to activity_path(activity)
  end

  def logout
    reset_session
    redirect_to action: :landing
  end
end
