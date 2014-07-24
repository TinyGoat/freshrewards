FreshRewards::Application.routes.draw do
  root "profiles#show"
  get "home/faqs"
  get "home/learn_more"
  get "home/customer_service"

  resource :profile, only: :show

  namespace :admin do
    resource :enrollment,   only: [:new, :create]
    resource :transaction,  only: [:new, :create]
  end

  resources :inquiries, :only => [:new, :create] do
    get 'thank_you', :on => :collection
  end
end

