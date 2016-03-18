require 'rails_helper'

def login_user(user = nil)
  user ||= create(:user)
  session[:user_id] = user.id
end

RSpec.describe HomeController, 'GET#index' do
  # context 'if users is not logged in' do
  #   it 'redirects to Twitter' do
  #   end
  # end
  #
  # context 'if user is in the middle ' do
  # end
  it 'responds successfully' do
    login_user
    get :index
    expect(response).to have_http_status(:ok)
  end
end

RSpec.describe HomeController, 'GET#unfriendly_users' do
  let(:unfriendly_users) { double('unfriendly_users') }

  before do
    login_user
    TwitterUserConnector.any_instance.stub(unfriendly_users: unfriendly_users)
  end

  it 'responds successfully' do
    # check before

    get :unfriendly_users

    expect(response).to have_http_status(:ok)
  end

  it 'assigns users' do
    # check before

    get :unfriendly_users

    expect(assigns(:users)).to eq unfriendly_users
  end
end

describe HomeController, 'POST #unfollow_users' do
  let(:twitter_response) { [{}, {}] }
  let(:connector) { double(unfollow_users: twitter_response) }

  before do
    login_user
    TwitterUserConnector.stub(new: connector)
  end

  it 'unfollows the pointed users' do
    # check before

    post :unfollow_users, users_ids: '1,2'

    expect(connector).to have_received(:unfollow_users).with(%w(1 2))
  end

  it 'responds successfully' do
    # check before

    post :unfollow_users, users_ids: '1,2'

    expect(response).to have_http_status(:ok)
  end

  it 'assigns users' do
    #check before

    post :unfollow_users, users_ids: '1,2'

    expect(assigns(:users)).to eq(twitter_response)
  end
end
