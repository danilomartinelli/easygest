class User < ApplicationRecord
  CONFIRMATION_TOKEN_EXPIRY = 1.day

  has_secure_password validations: false

  before_save :downcase_email

  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP, message: "Email inválido" },
                    presence: { message: "Email é obrigatório" },
                    uniqueness: { message: "Email já cadastrado" }

  validates :password, presence: { message: "Senha é obrigatório" },
                       length: { minimum: 8,
                                 message: "Sua senha deve ter pelo menos 8 caracteres" }

  validates :password, confirmation: { allow_blank: true, message: "Deve ser igual a senha" }

  def confirm!
    self.confirmed_at = Time.zone.now
    save!
  end

  def confirmed?
    confirmed_at.present?
  end

  def unconfirmed?
    !confirmed?
  end

  def generate_confirmation_token
    signed_id expires_in: CONFIRMATION_TOKEN_EXPIRY, purpose: :confirm_email
  end

  private

  def downcase_email
    self.email = email.downcase
  end
end
