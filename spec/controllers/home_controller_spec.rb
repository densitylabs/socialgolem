require 'rails_helper'

describe HomeController, 'GET#index' do
  it 'responds successfully' do
    authenticate_user
    get :index
    expect(response).to have_http_status :ok
  end
end

describe HomeController, 'GET#unfriendly_users' do
  let(:unfriendly_users) { double('unfriendly_users') }

  before do
    authenticate_user
    TwitterUserConnector.any_instance.stub(unfriendly_users: unfriendly_users)
  end

  it 'responds successfully' do
    # check before
    get :unfriendly_users
    expect(response).to have_http_status :ok
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
    authenticate_user
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
    expect(response).to have_http_status :ok
  end

  it 'assigns users' do
    # check before
    post :unfollow_users, users_ids: '1,2'
    expect(assigns(:users)).to eq(twitter_response)
  end
end

describe HomeController, 'GET #users_im_unfriendly_with' do
  let(:users_im_unfriendly_with) { double('users_im_unfriendly_with') }

  before do
    authenticate_user
    TwitterUserConnector.any_instance.stub(
      users_im_unfriendly_with: users_im_unfriendly_with)
  end

  it 'responds successfully' do
    # check before
    get :users_im_unfriendly_with
    expect(response).to have_http_status :ok
  end

  it 'assigns users' do
    # check before
    get :users_im_unfriendly_with
    expect(assigns(:users)).to eq users_im_unfriendly_with
  end
end

describe HomeController, 'POST #follow_users' do
  let(:twitter_response) { [{}, {}] }
  let(:connector) { double(follow_users: twitter_response) }

  before do
    authenticate_user
    TwitterUserConnector.stub(new: connector)
  end

  it 'follows the pointed users' do
    # check before
    post :follow_users, users_ids: '1,2'
    expect(connector).to have_received(:follow_users).with(%w(1 2))
  end

  it 'responds successfully' do
    # check before
    post :follow_users, users_ids: '1,2'
    expect(response).to have_http_status :ok
  end

  it 'assigns users' do
    # check before
    post :follow_users, users_ids: '1,2'
    expect(assigns(:users)).to eq(twitter_response)
  end
end
