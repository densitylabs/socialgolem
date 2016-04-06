module Twitter
  class UsersController < ApplicationController
    before_action :validate_search_pattern, only: :filter_related_users

    def show
      if params[:id] && !params[:relation]
        return redirect_to(twitter_user_twitter_user_path(
          user_id: params[:id],
          relation: 'following'))
      end

      @user = TwitterUser.find_by(screen_name: params[:user_id])
    end

    def relations
      FindRelatedTwitterUsersJob.new.perform(connector.screen_name,
                                             params[:id],
                                             params[:relation_type])

      render plain: 'Users being fetched in the background. Expect broadcast message.'
    end

    def filter_related_users
      user = TwitterUser.find(params[:id])
      users = if params[:related_users] == 'friends'
                user.friends_by(params[:pattern], params[:page])
              else # followers
                user.followers_by(params[:pattern], params[:page])
              end

      render json: users
    end

    def follow_user
      connector.friend(params[:id])
    end

    private

    def validate_search_pattern
      return params[:pattern] = :id if params[:pattern].blank?

      unless TwitterUser::SUPPORTED_SEARCH_PATTERNS.include?(params[:pattern])
        return render text: "Invalid search pattern. Use "\
                            "#{TwitterUser::SUPPORTED_SEARCH_PATTERNS.inspect}.",
                      status: 403
      end
    end
  end
end
