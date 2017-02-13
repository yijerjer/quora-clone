class User < ActiveRecord::Base
	validates :email, uniqueness: true, format: { with: /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/, message: "invalid email" }
	validates :password, length: { minimum: 8, message: "too short" }
	has_secure_password
end
