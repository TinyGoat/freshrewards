FreshRewards::Application.routes.draw do
  root "profiles#show"
  get "home/faqs"

  devise_for :users

  resource :profile, only: :show

  namespace :admin do
    resource :enrollment,   only: [:new, :create]
    resource :transaction,  only: [:new, :create]
  end
end
