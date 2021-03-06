class User < ApplicationRecord
  has_many :accounts
  has_many :workspaces, through: :accounts

  CONFIRMATION_TOKEN_EXPIRY = 10.minutes
  PASSWORD_RESET_TOKEN_EXPIRATION = 10.minutes
  MAILER_FROM_EMAIL = "no-reply@easygest.xyz".freeze

  attr_accessor :current_password

  has_secure_password validations: false

  has_secure_token :remember_token

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

  def self.authenticate_by(attributes)
    passwords, identifiers = attributes.to_h.partition do |name, value|
      !has_attribute?(name) && has_attribute?("#{name}_digest")
    end.map(&:to_h)

    raise ArgumentError, "Um ou mais argumentos são requeridos" if passwords.empty?
    raise ArgumentError, "Um ou mais argumentos são requeridos" if identifiers.empty?
    if (record = find_by(identifiers))
      record if passwords.count { |name, value| record.public_send(:"authenticate_#{name}", value) } == passwords.size
    else
      new(passwords)
      nil
    end
  end

  def confirm!
    if unconfirmed_or_reconfirming?
      if unconfirmed_email.present? && !update(email: unconfirmed_email, unconfirmed_email: nil)
        return false
      end

      update_columns(confirmed_at: Time.current)
    else
      false
    end
  end

  def confirmable_email
    unconfirmed_email.presence || email
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
