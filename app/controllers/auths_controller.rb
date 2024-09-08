require "net/http"
require "uri"
require "json"

class AuthsController < ApplicationController
  before_action :set_user_data, only: %i[signup login]
  def signup_page; end

  def signup
    uri = URI("https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=#{Rails.application.credentials.firebase_api_key}")
    response = Net::HTTP.post_form(uri, "email": @email, "password": @password)
    data = JSON.parse(response.body)

    if(response.is_a?(Net::HTTPSuccess))
      session[:user_id] = data["localId"]
      session[:data] = data
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

    puts "#{data}"

    if(response.is_a?(Net::HTTPSuccess))
      session[:user_id] = data["localId"]
      session[:data] = data
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
end
