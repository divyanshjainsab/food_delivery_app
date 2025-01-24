Rails.application.routes.draw do
  # route for letter_opener_web
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?


  # root path
  root "user#index"

  # signup options
  get '/signup', to: "user#signup"

  # otp verification for registration
  get '/verify', to: "user#email_verification"
  post '/verify', to: "user#verification"

  resources :authentication, as: "auth", only: %i[ create new index ] 
  # we dont want to disclose all users information.
  namespace "users" do
    resource :clients, :restaurants, :riders
  end
end
