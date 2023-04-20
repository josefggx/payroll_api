Rails.application.routes.draw do
  get 'companies/index'
  get 'companies/create'
  namespace :v1, path: '/api/v1' do
    post '/auth/login', to: 'authentication#login'
    get '/users/current', to: 'users#current'
    resources :users
    resources :companies
  end
end
