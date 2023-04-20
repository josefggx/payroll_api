# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id              :uuid             not null, primary key
#  email           :string           not null
#  password_digest :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null

class User < ApplicationRecord
  validates :email, presence: { code: '0101' }, uniqueness: { code: '0102' }
  validates :password, length: { minimum: 6, code: '0103' }
  has_secure_password

  has_many :companies, dependent: :destroy
end
