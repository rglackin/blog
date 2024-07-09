class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  include Devise::JWT::RevocationStrategies::JTIMatcher
  has_many :articles, dependent: :destroy
  has_many :comments, dependent: :destroy
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self
  validates :name, presence: true, length: {minimum: 3, maximum: 15}, uniqueness: true
  before_create :set_admin
  
  # def on_jwt_dispatch(token, payload)
  #   puts "Token dispatched\n-------\n#{token}\n----------"
  #   self.jti = token
  #   puts self.jti
  # end

  
  private
  def set_admin
    self.admin = true unless User.exists?
  end
end
