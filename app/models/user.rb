class User < ApplicationRecord
	has_secure_password
	validates :email, presence: true, uniqueness: true
	validates :mobile_number, presence: true, uniqueness: true
	validates :mobile_number, format: { with: /\A\d{10}\z/, message: "must be 10 digits" }
end
