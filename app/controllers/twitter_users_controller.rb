class TwitterUsersController < ApplicationController
  def show
  end

  def relations
    LoadRelatedTwitterUsersJob.new.perform(cookies.signed[:user_id],
                                           params[:id],
                                           params[:relation_type])

    render plain: 'Users being fetched in the background. Expect broadcast message.'
  end
end
