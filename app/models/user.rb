# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  city                   :string
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  details                :string
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  firstname              :string
#  lastname               :string
#  location               :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  unconfirmed_email      :string
#  username               :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

class User < ApplicationRecord
  has_many :posts
  has_many :likes, dependent: :destroy

  before_destroy :destroy_dependencies

  validates :firstname, :lastname, :location, :city, :username, presence: true
  validates :firstname, :lastname, :city, :username, length: { minimum: 2, maximum: 25 }
  validates :location, length: { minimum: 2, maximum: 55 }


  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable

  has_one_attached :avatar

  private
  def destroy_dependencies
    posts.destroy_all
  end
end
