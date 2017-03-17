Rails.application.routes.draw do
  get 'tags/:id', to: 'assembly_controller#edittag', as: 'tag'
  delete 'tags/:id', to: 'assembly_controller#deletetag'
  patch 'tags/:id', to: 'assembly_controller#updatetag'
  get 'wallets/:id', to: 'assembly_controller#editwallet', as: 'wallet'
  delete 'wallets/:id', to: 'assembly_controller#deletewallet'
  patch 'wallets/:id', to: 'assembly_controller#updatewallet'

  devise_for :users
  root 'main_pages#home'
  get '/admin', to: 'main_pages#admin'
  get '/edit', to: 'main_pages#edit'
  put '/edit', to: 'main_pages#update'
  post '/edit', to: 'main_pages#new'
  patch '/edit', to: 'main_pages#importfile'

  get '/administrate/edit', to: 'administrate#edit'
  get '/administrate', to: 'administrate#delete'
  get '/administrate/new', to: 'administrate#new'
  post '/administrate/new', to: 'administrate#create'
  patch '/administrate/new', to: 'administrate#update'
  delete '/administrate', to: 'administrate#delete'

  resources :items
  get '/items/ajax/:id', to: 'items#ajax', as: 'ajax_item'
  get '/gajax', to: 'main_pages#graph'
  post '/', to: 'main_pages#export'

  # resource :administrate
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
