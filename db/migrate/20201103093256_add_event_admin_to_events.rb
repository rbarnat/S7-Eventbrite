class AddEventAdminToEvents < ActiveRecord::Migration[6.0]
  def change
    # Add column to event indicating and admin from the user model
    add_reference :events, :event_admin, foreign_key: {to_table: :users}
  end
end
