Rails.application.routes.draw do
  resources :appointments, only: [ :create ] do
    member do
      post "accept"
      post "reject"
    end
  end
  resources :nutritionists_services, only: [ :index ]
  resources :nutritionists, only: [] do
    member do
      get "pending_requests"
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
