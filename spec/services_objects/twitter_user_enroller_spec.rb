require 'spec_helper'
require 'twitter_oauth'
require './app/service_objects/twitter_user_enroller'

describe TwitterUserEnroller, '#request_token' do
  let(:request_token) { double('request_token') }
  let(:twitter_conf) { { key: 'key', secret: 'secret' } }

  it 'returns a new twitter request token' do
    TwitterOAuth::Client.any_instance.stub(request_token: request_token)
    enroller = TwitterUserEnroller.new(twitter_conf)

    result = enroller.request_token

    expect(result).to eq(request_token)
  end
end

describe TwitterUserEnroller, '#authorize_user' do
  let(:twitter_conf) { { key: 'key', secret: 'secret' } }
  let(:request_token) { double(token: 'request_token', secret: 'request_token_secret') }
  let(:access_token) { double(token: 'access_token', secret: 'access_token_secret') }
  let(:twitter_user_info) { { 'screen_name' => 'foo', 'name' => 'bar' } }
  let(:oauth_verifier) { '123' }

  context 'based on a request token and an oauth verifier' do
    it 'asks Twitter for an authorization token' do
      TwitterOAuth::Client.any_instance.stub(authorize: access_token)
      TwitterOAuth::Client.any_instance.stub(info: twitter_user_info)
      enroller = TwitterUserEnroller.new(twitter_conf)

      expect_any_instance_of(TwitterOAuth::Client).to receive(:authorize)
        .with(request_token.token,
              request_token.secret,
              oauth_verifier: oauth_verifier)

      result = enroller.authorize_user(request_token, oauth_verifier)
    end
  end

  context 'based on an authorization token asked to Twitter' do
    it 'creates a user in the database' do
      TwitterOAuth::Client.any_instance.stub(authorize: access_token)
      TwitterOAuth::Client.any_instance.stub(info: twitter_user_info)
      enroller = TwitterUserEnroller.new(twitter_conf)

      result = enroller.authorize_user(request_token, oauth_verifier)

      expect(result['screen_name']).to eq(twitter_user_info['screen_name'])
      expect(result['name']).to eq(twitter_user_info['name'])
      expect(result['token']).to eq(access_token.token)
      expect(result['secret']).to eq(access_token.secret)
    end
  end
end
