Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "queries#index"
  resources :eviction_notices, only: [:index, :show]

  resources :queries, only: [:index, :show, :create]
  post "/run_query" => "queries#run_query"
end
