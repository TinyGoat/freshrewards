FreshRewards::Application.routes.draw do
  devise_for :customers
  root "profiles#show"
  get "home/faqs"
  get "home/learn_more"
  get "home/customer_service"
  get 'home/new', as: 'home_contact_us'

  get 'sign-in',  to: 'sessions#create',  as: 'sign_in'
  get 'sign-out', to: 'sessions#destroy', as: 'sign_out'
  get 'home/unauthorized', as: 'unauthenticated'

  resources :profiles, only: :show

  namespace :admin do
    resource :enrollment,   only: [:new, :create]
    resource :transaction,  only: [:new, :create]
  end

  resources :inquiries, :only => [:new, :create] do
    get 'thank_you', :on => :collection
  end
end

