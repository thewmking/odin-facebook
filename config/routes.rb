Rails.application.routes.draw do
  devise_for :users, :controllers => { registrations: 'registrations' }
  resources  :users,       only: [:index, :show]
  resources  :users_admin
  resources  :posts,       only: [:index, :create, :destroy]
  resources  :likes,       only: [:create, :destroy]
  resources  :comments,    only: [:create, :destroy]
  resources  :friendships, only: [:create, :update, :destroy]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

root to: "posts#index"

end
