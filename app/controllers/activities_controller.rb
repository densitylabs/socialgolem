class ActivitiesController < ApplicationController
  def show
    @activity = Activities::FriendshipBatchChange.find(params[:id])
    @processed_twitter_users = connector.fetch_users_based_on_ids(
      @activity.processed_twitter_users_ids, identifier: 'screen_name')
    @unprocessed_twitter_users = connector.fetch_users_based_on_ids(
      @activity.unprocessed_twitter_users_ids)
  end

  private

  def connector
    @connector ||= TwitterUserConnector.new(User.find(session[:user_id]))
  end
end
