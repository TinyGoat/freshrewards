FreshRewards::Application.routes.draw do
  root "home#index"
  get "home/faqs"
  devise_for :users

  namespace :admin do
    resource :enrollment, only: [:new, :create]
  end
end
