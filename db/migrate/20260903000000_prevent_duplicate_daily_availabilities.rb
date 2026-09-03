class PreventDuplicateDailyAvailabilities < ActiveRecord::Migration[8.1]
  def change
    add_index :availabilities,
              "staff_member_id, (DATE(starts_at))",
              unique: true,
              name: "index_availabilities_on_staff_member_and_start_date"
  end
end