class ConfirmationsController < ApplicationController
  before_action :redirect_if_authenticated, only: [:create, :new]

  def create
    @user = User.find_by(email: params[:user][:email].downcase)

    if @user.present? && @user.unconfirmed?
      @user.send_confirmation_email!
      redirect_to root_path, notice: "Cheque seu email para confirmar sua conta."
    else
      redirect_to :confirmation_view, alert: "Nós não encontramos um usuário com esse email ou já foi confirmado."
    end
  end

  def edit
    @user = User.find_signed(params[:confirmation_token], purpose: :confirm_email)

    if @user.present?
      if @user.confirm!
        login @user
        redirect_to root_path, notice: "Sua conta foi confirmada."
      else
        redirect_to :confirmation_view, alert: "Algo deu errado."
      end
    else
      redirect_to :confirmation_view, alert: "Token inválido."
    end
  end

  def new
    @user = User.new
  end
end
