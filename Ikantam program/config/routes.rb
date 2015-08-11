Rails.application.routes.draw do

  namespace :oauth do
    get 'google_plus/connect'
    get 'google_plus/callback'
    get 'twitter/connect'
    get 'twitter/callback'
    get 'facebook/connect'
    get 'facebook/callback'
    get 'instagram/connect'
    get 'instagram/callback'
  end

  devise_for :users, controllers: { passwords: "users/passwords", omniauth_callbacks: 'omniauth_callbacks', sessions: "users/sessions" }
  get 'users/finish_signup', :as => :finish_signup
  patch 'users/finish_signup', :as => :patch_finish_signup
  devise_scope :user do
    # set up roots

    authenticated :user, ->(u) { !u.email_verified? } do
      root to: 'users#finish_signup', as: :verify_email_root
    end

    authenticated :user do
      root to: 'hashtags#index', as: :authenticated_root
    end

    root to: 'devise/sessions#new'

    get "users/password/success" => 'users/passwords#successfuly_sent'
  end
  # get 'users/password/success', to: 'users/passwords#successfuly_sent'
  resources :user do
    get 'users/validate_email'
    get 'users/validate_username'
  end

  resources :hashtags

end
