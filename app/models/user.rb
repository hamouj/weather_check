# frozen_string_literal: true

# app/models/user.rb
class User < ApplicationRecord
  before_save :generate_api_key

  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, confirmation: true
  validates :password_confirmation, presence: true

  has_secure_password

  private

  def generate_api_key
    self.api_key = SecureRandom.hex
  end
end
