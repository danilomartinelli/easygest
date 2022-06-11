class User < ApplicationRecord
  CONFIRMATION_TOKEN_EXPIRY = 1.day

  has_secure_password

  before_save :downcase_email

  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, presence: true, uniqueness: true

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
