class User < ApplicationRecord
  CONFIRMATION_TOKEN_EXPIRY = 10.minutes
  PASSWORD_RESET_TOKEN_EXPIRATION = 10.minutes
  MAILER_FROM_EMAIL = "no-reply@easygest.xyz".freeze

  attr_accessor :current_password

  has_secure_password validations: false

  before_save :downcase_email

  before_save :downcase_unconfirmed_email

  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP, message: "Email inválido" },
                    presence: { message: "Email é obrigatório" },
                    uniqueness: { message: "Email já cadastrado" }

  validates :unconfirmed_email,
            format: { with: URI::MailTo::EMAIL_REGEXP, allow_blank: true, message: "Email inválido" }

  validates :password, presence: { message: "Senha é obrigatório" },
                       length: { minimum: 8,
                                 message: "Sua senha deve ter pelo menos 8 caracteres" }

  validates :password, confirmation: { allow_blank: true, message: "Deve ser igual a senha" }

  def confirm!
    if unconfirmed_or_reconfirming?
      if unconfirmed_email.present?
        return false unless update(email: unconfirmed_email, unconfirmed_email: nil)
      end
      update_columns(confirmed_at: Time.current)
    else
      false
    end
  end

  def confirmable_email
    if unconfirmed_email.present?
      unconfirmed_email
    else
      email
    end
  end

  def reconfirming?
    unconfirmed_email.present?
  end

  def unconfirmed_or_reconfirming?
    unconfirmed? || reconfirming?
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

  def downcase_unconfirmed_email
    return if unconfirmed_email.nil?
    self.unconfirmed_email = unconfirmed_email.downcase
  end

  def downcase_email
    self.email = email.downcase
  end
end
