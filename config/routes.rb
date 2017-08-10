Rails.application.routes.draw do
  devise_for :users, :controllers => { registrations: 'registrations' }
  resources :users_admin, :controller => 'users'
  resources :posts
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

root to: "users#index"
get '/users/:id', to: 'users#show'

end
