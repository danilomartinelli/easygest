class SessionsController < ApplicationController
  before_action :redirect_if_authenticated, only: [:create, :new]

  def create
    @user = User.find_by(email: params[:user][:email].downcase)
    if @user
      if @user.unconfirmed?
        redirect_to :confirmation_view, alert: "Email ainda não confirmado."
      elsif @user.authenticate(params[:user][:password])
        after_login_path = session[:user_return_to] || :dashboard_view
        login @user
        remember(@user) if params[:user][:remember_me] == "1"
        redirect_to after_login_path, notice: "Signed in."
      else
        flash.now[:alert] = "Email ou senha incorreto."
        render :new, status: :unprocessable_entity
      end
    else
      flash.now[:alert] = "Email ou senha incorreto."
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    forget(current_user)
    logout
    redirect_to root_path, notice: "Deslogado."
  end

  def new; end
end
