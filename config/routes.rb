Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "eviction_notices#index"
  resources :eviction_notices, only: [:index, :show] do
    collection { post :run_query }
  end

  resources :queries, only: [:create]
end
