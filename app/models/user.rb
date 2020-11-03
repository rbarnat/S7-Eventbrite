class User < ApplicationRecord
  after_create :welcome_send


  has_many :attendances
  has_many :events, through: :attendances

  has_many :admin_events, foreign_key: "event_admin_id", class_name: "Event", dependent: :destroy

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, uniqueness: true 
  # format: { with: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/, message: "email adress please" }
  
  
  def welcome_send
    UserMailer.welcome_email(self).deliver_now
  end
end
