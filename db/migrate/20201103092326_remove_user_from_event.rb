class RemoveUserFromEvent < ActiveRecord::Migration[6.0]
  def change
    remove_reference :events, :user, null: false, foreign_key: true
  end
end
