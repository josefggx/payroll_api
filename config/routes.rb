Rails.application.routes.draw do
  namespace :v1, path: '/api/v1' do
    post '/auth/login', to: 'authentication#login'
    get '/users/current', to: 'users#current'
    resources :users
    resources :companies do
      resources :workers
      resources :contracts, only: %i[index show update] do
        resources :wages, only: %i[index create], module: :contracts
        get '/current_wage', to: 'contracts/current_wage#show'
        put '/current_wage', to: 'contracts/current_wage#update'
        delete '/current_wage', to: 'contracts/current_wage#destroy'
      end
      resources :periods, only: %i[index create show destroy]
      resources :payrolls, only: %i[index create show destroy] # TODO: remove the create route at the end version
    end
  end
end
