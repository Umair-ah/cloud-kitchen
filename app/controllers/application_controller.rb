class ApplicationController < ActionController::Base

  before_action :init_cart
  helper_method :current_user

  def current_user
    @current_user ||= session[:user_id]
  end

  private

  def init_cart
    curr_user = User.find_by(uid: session[:user_id])
  
    if curr_user
      cart = curr_user.cart || Cart.create!(user: curr_user)
    else
      cart = if cookies.signed[:cart_id].present?
               Cart.find_by(id: cookies.signed[:cart_id]) || Cart.create!
             else
               Cart.create!
             end
    end
  
    cookies.signed[:cart_id] = { value: cart.id, expires: 1.week.from_now }
  
    @current_cart = cart
    response.headers['Cart-ID'] = @current_cart.id.to_s
  end


end
