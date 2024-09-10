Rails.application.routes.draw do
  resources :categories, param: :title do 
    resources :products, param: :title, except: %i[index]
  end
  get "auth/signup", to: "auths#signup_page"
  get "auth/login", to: "auths#login_page"


  post "auth/signup", to: "auths#signup", as: "signup"
  post "auth/login", to: "auths#login", as: "login"
  post "auth/logout", to: "auths#logout"

  root "homes#home"

  post "auth/google_login", to: "auths#google_login"

  get "cart/:cart_id", to: "carts#show", as: :cart

  
end
