Rails.application.routes.draw do

  devise_for :users

  resources :users
  resources :posts
  resources :replies


  # get "replies/create_reply" => 'reply#new_reply', :as => :reply_new
  # get '/posts/:id', to: 'posts#show', as: 'post'
  # get "posts/new" => 'post#new', :as => :new



  root to: 'pages#home'

  match '/403', to: 'errors#error_403', via: :all
  match '/404', to: 'errors#error_404', via: :all
  match '/422', to: 'errors#error_422', via: :all
  match '/500', to: 'errors#error_500', via: :all

  get :ie_warning, to: 'errors#ie_warning'
  get :javascript_warning, to: 'errors#javascript_warning'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
