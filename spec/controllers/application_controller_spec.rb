require 'rails_helper'

describe ApplicationController do
  controller do
    def index
      render nothing: true
    end
  end

  context 'if users is not logged in' do
    it 'redirects to Twitter' do
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

  context 'if users is logged in', focus: true do
    it 'responds with status ok' do
      authenticate_user
      get :index
      expect(response).to have_http_status(200)
    end
  end
end
