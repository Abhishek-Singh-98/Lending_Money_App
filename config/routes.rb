Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  root "signups#signup_page"
  post 'user_signup', to: "signups#signup_user"
  post 'login', to:"logins#login_user"

  resource :login, only: [:new]

  resources :users, only: [:edit, :update, :show, :destroy] do
    resources :loan_requests
    get 'my_loan_requests', to: "users#my_loan_requests"
  end
end
