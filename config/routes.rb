Rails.application.routes.draw do
  namespace :v1, path: '/api/v1', defaults: { format: :json } do
    post '/auth/login', to: 'authentication#login'
    get '/users/current', to: 'users#current'
    resources :users
    resources :companies do
      resources :workers do
        resources :payrolls, only: [:index], controller: 'worker_payrolls', module: :workers
      end
      resources :contracts, only: %i[index show update] do
        resources :wages, only: %i[index create], module: :contracts
        get '/current_wage', to: 'contracts/current_wage#show'
        put '/current_wage', to: 'contracts/current_wage#update'
        delete '/current_wage', to: 'contracts/current_wage#destroy'
      end
      resources :periods, only: %i[index create show destroy] do
        resources :payrolls, only: [:index], controller: 'period_payrolls', module: :periods
      end
      resources :payrolls, only: %i[index create show destroy]
      resources :payroll_additions
    end
  end
end
