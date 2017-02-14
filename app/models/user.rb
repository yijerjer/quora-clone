class User < ActiveRecord::Base
	has_many :questions
	has_many :answers

	validates :email, uniqueness: { message: "Email already in use." }, format: { with: /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/, message: "Invalid email." }
	validates :password, length: { minimum: 8, message: "Password must have a minimum of 8 characters." }
	has_secure_password
end
