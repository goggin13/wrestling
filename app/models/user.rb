class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def admin?
    email == "goggin13@gmail.com"
  end

  def encoded_email
    Base64.encode64(email).chomp
  end
end
