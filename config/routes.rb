Rails.application.routes.draw do
  devise_for :users, :controllers => { registrations: 'registrations',
                                       omniauth_callbacks: 'users/omniauth_callbacks' }
  resources  :users,       only: [:index, :show]
  resources  :users_admin
  resources  :posts
  resources  :likes,       only: [:create, :destroy]
  resources  :comments,    only: [:create, :destroy]
  resources  :friendships, only: [:create, :update, :destroy]
  resources  :notifications

  get 'notifications/:id/link_through', to: 'notifications#link_through',
                                        as: :link_through

  root to: "posts#index"

end
