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
      get "action_on_loan", to: "loan_requests#admin_approve_reject_loan_request"
    end
    get 'my_loans', to: "users#my_loans"
  end
end
