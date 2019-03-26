require 'sidekiq/web'
Rails.application.routes.draw do
  get 'divide/', to: 'divide#index'
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  mount Sidekiq::Web => '/admin/sidekiq'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
