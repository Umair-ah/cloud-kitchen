require "net/http"
require "uri"
require "json"

class AuthsController < ApplicationController
  before_action :set_user_data, only: %i[signup login]
  before_action :authenticate_user, only: %i[signup_page login_page]
  skip_before_action :verify_authenticity_token, only: [:google_login]


  def google_login
    id_token = params[:idToken]

    creds = Firebase::Admin::Credentials.from_file('config/service_account.json')
    app = Firebase::Admin::App.new(credentials: creds)
    auth = app.auth

    decoded_token = auth.verify_id_token(id_token)
    puts decoded_token

    if decoded_token["user_id"]
      # user = User.find_or_create_by(email: decoded_token['email']) do |user|
      #   user.name = decoded_token['name']
      # end
      session[:user_id] = decoded_token["user_id"]
      render json: { success: true, redirect_url: root_path }
      #redirect_to root_path, notice: "Signed In with Google Successfully"
    else
      render json: { success: false, message: "Google login failed" }, status: :unauthorized
      redirect_to login_path, alert: "Google login failed"
    end
  end

  def signup_page; end

  def signup
    uri = URI("https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=#{Rails.application.credentials.firebase_api_key}")
    response = Net::HTTP.post_form(uri, "email": @email, "password": @password)
    data = JSON.parse(response.body)

    if(response.is_a?(Net::HTTPSuccess))
      session[:user_id] = data["localId"]
      respond_to do |format|
        format.html { redirect_to root_path, notice: "Signed Up Successfully"  } 
        format.json { render json: data, status: :unprocessable_entity } 
      end
    elsif data["error"]["message"] == "EMAIL_EXISTS"
      respond_to do |format|
        format.html { redirect_to signup_path, alert: "Email already exists. Please try a different email." }
        format.json { render json: { error: "Email already exists" }, status: :unprocessable_entity }
      end
    elsif data["error"]["message"] == "WEAK_PASSWORD : Password should be at least 6 characters"
      respond_to do |format|
        format.html { redirect_to signup_path, alert: "Password should be at least 6 characters" }
        format.json { render json: { error: "Password should be at least 6 characters" }, status: :unprocessable_entity }
      end
    end
  end

  def login_page; end

  def login
    uri = URI("https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=#{Rails.application.credentials.firebase_api_key}")
    response = Net::HTTP.post_form(uri, "email": @email, "password": @password)
    data = JSON.parse(response.body)


    if(response.is_a?(Net::HTTPSuccess))
      session[:user_id] = data["localId"]
      respond_to do |format|
        format.html { redirect_to root_path, notice: "Signed Up Successfully"  } 
        format.json { render json: data, status: :unprocessable_entity } 
      end
    elsif data["error"]["message"] == "INVALID_LOGIN_CREDENTIALS"
      respond_to do |format|
        format.html { redirect_to login_path, alert: "Invalid Email Or Password" }
        format.json { render json: { error: "Invalid Email Or Password" }, status: :unprocessable_entity }
      end
    end
  end

  def logout
    session.clear
    redirect_to root_path, notice: "Logged out successfully"

  end

  private

  def set_user_data
    @email = params[:email]
    @password = params[:password]
  end

  def authenticate_user
    redirect_to root_path, alert: "You must be logged in to view this page" if current_user
  end
end
