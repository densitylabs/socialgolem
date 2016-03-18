class OauthController < ApplicationController
  def callback
    enroller = TwitterUserEnroller.new
    user = enroller.authorize_and_create_user(session[:request_token],
                                              params[:oauth_verifier])
    session[:request_token] = nil
    session[:user_id] = user.id

    redirect_to root_path
  end
end
