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
  get "cart/:cart_id/checkout", to: "carts#checkout", as: :checkout

  post "/order", to: "carts#order", as: :order

  get "/success", to: "carts#success", as: :success
  get "/failure", to: "carts#failure", as: :failure



  # line_items (add to cart, add quantity, subtract quantity, remove from cart)
  post "/add_to_cart", to: "line_items#add_to_cart", as: :add_to_cart
  patch "/update_quantity", to: "line_items#update_quantity", as: :update_quantity
  delete "/remove_from_cart", to: "line_items#remove_from_cart", as: :remove_from_cart



  
end
