# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users

  resources :users do
    member do
      get :home
      post :ban_user
      post :unblock_user
    end
  end

  resources :posts do
    resources :likes

    resources :ratings

    resources :poll_options do
      resources :poll_option_records
    end

    collection do
      get :search
      get :advanced_search
      post :show_post_modal
    end
  end

  resources :create_polls

  resources :replies do
    resources :likes
    member do
      post :show_reply_modal
    end
  end

  resources :reports do
    member do
      post :show_report_modal
    end
  end

  resources :app_requests do
    member do
      post :done
      post :new_app_post
    end
  end

  root to: 'posts#home'

  match '/403', to: 'errors#error_403', via: :all
  match '/404', to: 'errors#error_404', via: :all
  match '/422', to: 'errors#error_422', via: :all
  match '/500', to: 'errors#error_500', via: :all

  get :ie_warning, to: 'errors#ie_warning'
  get :javascript_warning, to: 'errors#javascript_warning'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
