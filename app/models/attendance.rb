class Attendance < ApplicationRecord
  after_create :new_attendance_send

  belongs_to :user
  belongs_to :event

  def new_attendance_send
    UserMailer.new_attendance_email(self).deliver_now
  end
end
