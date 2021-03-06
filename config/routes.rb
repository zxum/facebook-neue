Rails.application.routes.draw do
  resources :profiles
  devise_for :users, :controllers => { registrations: 'registrations', omniauth_callbacks: 'users/omniauth_callbacks' }
  resources :users, only: [:index, :show]
  resources :posts do
    resource :like
    resources :comments 
  end
  resources :friendships
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "posts#index"
end
