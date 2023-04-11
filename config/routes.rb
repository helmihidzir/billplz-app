Rails.application.routes.draw do
  resources :main, only: %i[index show create] do
    collection do
      get :callback
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
