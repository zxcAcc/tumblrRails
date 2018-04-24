Rails.application.routes.draw do
  devise_for :admins
  mount Ckeditor::Engine => '/ckeditor'
  root to: "posts#index"

  resources :posts
  resources :comments, only: [:create, :index, :destroy]
end
