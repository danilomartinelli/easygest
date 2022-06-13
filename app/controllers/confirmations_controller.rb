class ConfirmationsController < ApplicationController

  def create
    @user = User.find_by(email: params[:user][:email].downcase)

    if @user.present? && @user.unconfirmed?
      redirect_to root_path, notice: "Cheque seu email para confirmar sua conta."
    else
      redirect_to :new_confirmation, alert: "Nós não encontramos um usuário com esse email ou já foi confirmado."
    end
  end

  def edit
    @user = User.find_signed(params[:confirmation_token], purpose: :confirm_email)

    if @user.present?
      @user.confirm!
      redirect_to root_path, notice: "Sua conta foi confirmada."
    else
      redirect_to :new_confirmation, alert: "Token inválido."
    end
  end

  def new
    @user = User.new
  end

end