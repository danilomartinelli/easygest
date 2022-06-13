class PasswordsController < ApplicationController
  before_action :redirect_if_authenticated

  def create
    @user = User.find_by(email: params[:user][:email].downcase)
    if @user.present?
      if @user.confirmed?
        @user.send_password_reset_email!
        redirect_to root_path, notice: "Se o usuário existir, iremos enviar informações de troca de senha."
      else
        redirect_to :confirmation_view, alert: "Por favor, confirme seu email primeiro."
      end
    else
      redirect_to root_path, notice: "Se o usuário existir, iremos enviar informações de troca de senha."
    end
  end

  def edit
    @user = User.find_signed(params[:password_reset_token], purpose: :reset_password)
    if @user.present? && @user.unconfirmed?
      redirect_to :confirmation_view, alert: "Você deve confirmar seu email antes de tentar entrar."
    elsif @user.nil?
      redirect_to new_password_view_path, alert: "Token inválido ou expirado."
    end
  end

  def new; end

  def update
    @user = User.find_signed(params[:password_reset_token], purpose: :reset_password)
    if @user
      if @user.unconfirmed?
        redirect_to confirmation_view, alert: "Você deve confirmar seu email antes de tentar entrar."
      elsif @user.update(password_params)
        redirect_to login_path, notice: "Logado."
      else
        flash.now[:alert] = @user.errors.full_messages.to_sentence
        render :edit, status: :unprocessable_entity
      end
    else
      flash.now[:alert] = "Token inválido ou expirado."
      render :new, status: :unprocessable_entity
    end
  end

  private

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
