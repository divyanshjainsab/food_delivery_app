Rails.application.routes.draw do
  namespace "user" do
    resources :clients, :restaurants, :riders
  end
end
