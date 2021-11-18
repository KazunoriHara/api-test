Rails.application.routes.draw do
  resources :users
  post 'users/:id/:name' => 'users#add'
  get 'lottery' => 'users#lottery'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
