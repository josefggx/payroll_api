Rails.application.routes.draw do
  namespace :v1, path: '/api/v1' do
    post '/auth/login', to: 'authentication#login'
    get '/users/current', to: 'users#current'
    resources :users
    resources :companies do
      resources :workers
      resources :contracts
      resources :wages
    end
  end
end
