require 'rails_helper'

describe ApplicationController do
  controller do
    before_action :require_authentication

    def index
      render nothing: true
    end
  end

  context 'if users is not logged in' do
    it 'redirects to Twitter' do
      request_token = double(authorize_url: 'http://foo.bar')
      TwitterOAuth::Client.any_instance.stub(request_token: request_token)
      get :index
      expect(response).to have_http_status(302)
    end
  end

  context 'if users in the middle of the authentication' do
    it 'responds with status ok' do
      get :index, oauth_verifier: '1234'
      expect(response).to have_http_status(200)
    end
  end

  context 'if users is logged in' do
    it 'responds with status ok' do
      authenticate_user
      get :index
      expect(response).to have_http_status(200)
    end
  end
end
