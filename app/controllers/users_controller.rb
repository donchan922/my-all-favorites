class UsersController < ApplicationController
  def index
    @users = User.where(uid: session[:uid])
  end
end
