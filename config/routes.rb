Rails.application.routes.draw do
#   get 'home_controller/index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: 'home#index'
  get '/about',   to: 'home#index'
  get '/contact', to: 'home#index'

  namespace :api, format: 'json' do
    resources :tasks, only: [:index, :show, :create, :update]
  end
end
