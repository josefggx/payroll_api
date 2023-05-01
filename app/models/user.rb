# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id              :uuid             not null, primary key
#  email           :string           not null
#  password_digest :string           not null
#
class User < ApplicationRecord
  include StringValidations

  has_many :companies, dependent: :destroy

  validates :email, presence: true,
                    uniqueness: true,
                    format: { with: proc { |w| w.regex_valid_email }, if: -> { email.present? } }

  validates :password, length: { minimum: 6 }
  has_secure_password
end
