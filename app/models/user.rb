# frozen_string_literal: true

# app/models/user.rb
class User < ApplicationRecord
  validates :email, :password, presence: true
  validates :email, uniqueness: true

  has_secure_password
end