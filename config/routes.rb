require 'sidekiq/web'
Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  root "signups#signup_page"
  post 'user_signup', to: "signups#signup_user"
  post 'login', to:"logins#login_user"

  resource :login, only: [:new]

  resources :users, only: [:edit, :update, :show, :destroy] do
    resources :loan_requests do
      get 'repay_loan', to: "loan_requests#repay_full_loan"
      get "action_on_loan", to: "loan_requests#admin_approve_reject_loan_request"
    end
    resource :wallet, only: [:show, :edit, :update]
    get 'my_loans', to: "users#my_loans"
    get 'logout', to: "users#logout_user"
  end

  mount Sidekiq::Web => '/sidekiq'
end
