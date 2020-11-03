class Event < ApplicationRecord
  has_many :attendances
  has_many :users, through: :attendances

  belongs_to :event_admin, class_name: 'User'


  #DATE DE DEBUT
  validates :start_date, presence: true
  validate :start_must_be_in_future
  def start_must_be_in_future
    errors.add(:start_date, "la date doit être postérieure à aujourd'hui") unless
      start_date >= Time.now
  end 

  #DUREE
  validates :duration, presence: true, numericality: { greater_than_or_equal_to: 5 }
  validate :duration_must_be_multiple_of_5
  def duration_must_be_multiple_of_5
    errors.add(:duration, "la duréé doit être un multiple de 5") unless
      duration % 5 == 0
  end 
  
  #TITRE
  validates :title, presence: true, length: { minimum: 5, maximum: 140 }
  
  #DESCRIPTION
  validates :description, presence: true, length: { minimum: 20, maximum: 1000 }

  #PRICE
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 1000 }

  #LOCALISATION
  validates :location, presence: true

end
