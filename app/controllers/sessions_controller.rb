class SessionsController < ApplicationController
  before_action :redirect_if_authenticated, only: [:create, :new]

  def create
    @user = User.authenticate_by(email: params[:user][:email].downcase, password: params[:user][:password])
    if @user
      if @user.unconfirmed?
        redirect_to :confirmation_view, alert: "Confirme seu email."
      else
        after_login_path = session[:user_return_to] || :dashboard_view
        login @user
        remember(@user) if params[:user][:remember_me] == "1"
        redirect_to after_login_path, notice: "Seja Bem Vindo!"
      end
    else
      flash.now[:alert] = "Email e/ou senha incorreto(s)."
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
