Rails.application.routes.draw do
  devise_for :users

  unauthenticated :user do
    root 'home#index', as: :unauthenticated_root
  end

  authenticated :user do
    root 'projects#index', as: :authenticated_root
  end

  resources :projects do
    resources :tasks, only: [:new, :create, :update, :destroy]
  end
end
