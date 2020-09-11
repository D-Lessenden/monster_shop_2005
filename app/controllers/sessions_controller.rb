class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:email])
    if user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:success] = "Welcome, #{user.name}, you are logged in!"
      if current_merchant?
        redirect_to "/merchant"
      elsif current_admin?
        redirect_to "/admin"
      else
        redirect_to "/profile"
      end
    else
      flash[:error] = "Sorry, your credentials are bad."
      render :new
    end
  end
end
