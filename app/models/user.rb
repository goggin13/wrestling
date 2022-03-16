class User < ApplicationRecord
  include ActionView::Helpers::NumberHelper
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :validatable

  has_one_attached :avatar
  has_many :bets, dependent: :destroy

  def admin?
    email == "goggin13@gmail.com"
  end

  def display_name
    email.split("@")[0]
  end

  def encoded_email
    Base64.encode64(email).chomp
  end

  def formatted_balance
    number_to_currency(balance)
  end
end
