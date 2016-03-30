Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # Serve websocket cable requests in-process
  mount ActionCable.server => '/cable'

  root 'home#landing'
  get 'home/', to: 'home#index'

  namespace :home do
    get 'unfriendly_users'
    get 'users_im_unfriendly_with'
    post 'unfollow_users'
    post 'follow_users'
    get 'logout'
  end

  resources :activities, only: :show
  resources :twitter_users, only: :show do
    get :relations, on: :member
    get :filter_related_users, on: :member
  end

  get '/oauth/callback', to: 'oauth#callback'
end
