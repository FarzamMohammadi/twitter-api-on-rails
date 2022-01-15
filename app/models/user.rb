require 'bcrypt'

class User < ApplicationRecord
  include BCrypt

  PASSWORD_FORMAT = /\A
    (?=.{8,})          # Must contain 8 or more characters
    (?=.*\d)           # Must contain a digit
    (?=.*[a-z])        # Must contain a lower case character
    (?=.*[A-Z])        # Must contain an upper case character
    (?=.*[[:^alnum:]]) # Must contain a symbol
  /x

  validates :password,
  presence: true,
  length: { in: Devise.password_length },
  format: { with: PASSWORD_FORMAT },
  confirmation: true,
  on: :create

  validates :username,
  presence: true

  # Encrypt password
  after_validation(on: :create) do
  self.password= Password.create(:password)
  end

end
