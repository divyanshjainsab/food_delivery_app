Rails.application.routes.draw do
  # route for letter_opener_web
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?


  # root path
  root "user#index"

  # signup options
  get "/signup", to: "user#signup"

  # otp verification for registration
  get "/verify", to: "user#email_verification"
  post "/verify", to: "user#verification"
  get "resend_otp", to: "user#resend_otp"

  # logout
  get "/logout", to: "authentication#logout", as: "auth"

  resources :authentication, as: "auth", only: %i[ create new]
  # we dont want to disclose all users information.
  namespace "users" do
    resource :clients, :restaurants, :riders, only: %i[new create]
  end

  namespace "restaurant" do
    resources :dishes
  end
  # the above routes are for managing dishes of a restaurant

  get "/restaurants", to: "users/restaurants#index"
  get "/restaurants/:id", to: "users/restaurants#show"


  # these routes for payments
  resources :payments, only: [:new, :create ]

  get '/cancel', to: "payments#cancel"
  get '/success', to: "payments#success"
  
end
