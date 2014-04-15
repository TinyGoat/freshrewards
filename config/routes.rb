FreshRewards::Application.routes.draw do
  root "home#index"
  get "home/faqs"
  devise_for :users
end
