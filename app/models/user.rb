class User < ApplicationRecord
  CONFIRMATION_TOKEN_EXPIRY = 10.minutes
  PASSWORD_RESET_TOKEN_EXPIRATION = 10.minutes
  MAILER_FROM_EMAIL = "no-reply@easygest.xyz".freeze

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
    update_columns(confirmed_at: Time.current)
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

  def send_confirmation_email!
    confirmation_token = generate_confirmation_token
    UserMailer.confirmation(self, confirmation_token).deliver_now
  end

  def generate_password_reset_token
    signed_id expires_in: PASSWORD_RESET_TOKEN_EXPIRATION, purpose: :reset_password
  end

  def send_password_reset_email!
    password_reset_token = generate_password_reset_token
    UserMailer.password_reset(self, password_reset_token).deliver_now
  end

  private

  def downcase_email
    self.email = email.downcase
  end
end
