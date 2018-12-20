Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :short_urls
  root 'short_urls#index'

  get '/:id', to: 'short_urls#redirect_to_main_web', as: 'main_web'
end
