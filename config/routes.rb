Rails.application.routes.draw do
  devise_for :users, :controllers => { registrations: 'users/registrations', sessions: 'users/sessions', passwords: 'users/passwords'}
  root "articles#index"
  resources :articles do 
    resources :comments
    collection do
      get :search
    end
  end
  resources :users, only: [:show, :edit, :update]
  namespace :api do
    namespace :v1 do
      devise_for :users, :controllers => { registrations: 'api/v1/users/registrations', sessions: 'api/v1/users/sessions'}
      root "articles#index"
      resources :articles do
        resources :comments
        collection do
          get :search
        end
      end
      resources :users, only: [:show, :edit, :update]
    end
  end
end