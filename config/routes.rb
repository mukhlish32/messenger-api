Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :conversations, only: [:index, :show, :create] do
    resources :messages, only: [:index]
  end

  resources :messages, only: [:create, :show]
end
