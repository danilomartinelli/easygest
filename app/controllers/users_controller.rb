class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:edit, :destroy, :update]

  def create
    @user = User.new(create_user_params)

    if @user.save
      @user.send_confirmation_email!
      redirect_to root_path, notice: "Por favor, cheque seu email para confirmar sua conta."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    current_user.destroy
    reset_session
    redirect_to root_path, notice: "Sua conta foi deletada."
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.authenticate(params[:user][:current_password])
      if @user.update(update_user_params)
        if params[:user][:unconfirmed_email].present?
          @user.send_confirmation_email!
          redirect_to root_path, notice: "Cheque seu email para confirmar sua conta."
        else
          redirect_to root_path, notice: "Conta atualizada."
        end
      else
        render :edit, status: :unprocessable_entity
      end
    else
      flash.now[:error] = "Senha incorreta"
      render :edit, status: :unprocessable_entity
    end
  end

  def new
    @user = User.new
  end

  private

  def create_user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

  def update_user_params
    params.require(:user).permit(:current_password, :password, :password_confirmation, :unconfirmed_email)
  end
end
