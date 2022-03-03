class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :validatable

  has_one_attached :avatar

  def admin?
    email == "goggin13@gmail.com"
  end

  def encoded_email
    Base64.encode64(email).chomp
  end
end
