class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
  after_create :welcome_send


  has_many :attendances
  has_many :events, through: :attendances

  has_many :admin_events, foreign_key: "event_admin_id", class_name: "Event", dependent: :destroy

  has_one_attached :avatar
  after_commit :add_default_avatar, on: %i[create update]

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/, message: "Renseigne un email valide." }
  
  
  def welcome_send
    UserMailer.welcome_email(self).deliver_now
  end

  # def avatar_circle
  #   avatar.MiniMagick::Tool::Convert.new do |cvrt|
  #     cvrt.size '300x300'
  #     cvrt << 'xc:transparent'
  #     cvrt.fill 'image.png'
  #     cvrt.draw "circle 240,90 290,90"
  #     cvrt.crop '100x100+190+40'
  #     cvrt.repage.+
  #     cvrt << 'circle.png'
  #   end
  # end

  def avatar_thumbnail
    avatar.variant(resize: "30x30!").processed if avatar.attached?
  end

  def avatar_medium
    avatar.variant(resize: "200x200!").processed if avatar.attached?
  end

  def avatar_big
    avatar.variant(resize: "400x400!").processed if avatar.attached?
  end

  private

  def add_default_avatar
    unless avatar.attached?
      avatar.attach(
        io: File.open(
          Rails.root.join(
            'app', 'assets', 'images', 'default_profile.jpg' 
          )
        ), filename: 'default_profile.jpg',
        content_type: 'image/jpg'
      )
    end
  end
end
