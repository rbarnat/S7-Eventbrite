class CreateAttendances < ActiveRecord::Migration[6.0]
  def change
    create_table :attendances do |t|
      t.belongs_to :user, null: false, foreign_key: true, index: true
      t.belongs_to :event, null: false, foreign_key: true, index: true
      t.string :stripe_customer_id

      t.timestamps
    end
  end
end
