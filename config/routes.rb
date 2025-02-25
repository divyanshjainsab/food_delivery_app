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

  # otp verification for delivery
  get "resend_delivery_otp", to: "users/riders#resend_delivery_otp"
  get "/delivery", to: "users/riders#delivery_view"
  post "/deliver", to: "users/riders#delivery"


  # logout
  get "/logout", to: "authentication#logout", as: "auth"

  resources :authentication, as: "auth", only: %i[ create new]
  # we dont want to disclose all users information.
  namespace "users" do
    resource :clients, :restaurants, :riders, only: %i[new create]
  end

  namespace "restaurant" do
    resources :dishes
    resources :orders
  end
  get "/restaurant/orders_by_dish", to: "restaurant/orders#orders_by_dish"
  # the above routes are for managing dishes and restaurants of a restaurant

  namespace "user" do
    resources :orders
  end

  get "/restaurants", to: "users/restaurants#index"
  get "/restaurants/:id", to: "users/restaurants#show"


  # these routes for payments
  resources :payments, only: [ :new, :create ]

  get "/cancel", to: "payments#cancel"
  get "/success/:dish_id", to: "payments#success"

  # rider dashboard
  get "/rider/dashboard", to: "users/riders#index"

  # assign order to rider
  post "/rider/pick/:order_id", to: "users/riders#pick_order"


  # rating section
  resource :reviews, only: [ :new, :create ]

  # webhook
  post "/webhook", to: "webhooks#receive"
end
