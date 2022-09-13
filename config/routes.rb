Rails.application.routes.draw do
  devise_for :users

  unauthenticated :user do
    root 'home#index', as: :unauthenticated_root
  end

  authenticated :user do
    root 'dashboard#index', as: :authenticated_root
  end

  get 'profile', to: 'profile#index'
end
