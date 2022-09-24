# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  # Mock user_url that redirects to authenticated root because devise insists on using it as an after sign up redirect
  get "/users", to: redirect("/"), as: :user

  unauthenticated :user do
    root "home#index", as: :unauthenticated_root
  end

  authenticated :user do
    root "projects#index", as: :authenticated_root
  end

  resources :projects do
    # Since each task always belongs to a project
    resources :tasks, only: [:create, :update, :destroy, :edit, :new, :show]

    member do
      patch :move
    end
  end

  # But expose all tasks at /tasks as well (for the task list)
  resources :tasks, only: [:index]
  resources :tags, only: [:index, :new, :create, :destroy]
end
