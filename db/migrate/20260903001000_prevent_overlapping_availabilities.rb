class PreventOverlappingAvailabilities < ActiveRecord::Migration[8.1]
  def up
    remove_index :availabilities,
                 name: "index_availabilities_on_staff_member_and_start_date"

    enable_extension "btree_gist"

    execute <<~SQL
      ALTER TABLE availabilities
      ADD CONSTRAINT availabilities_no_overlapping_staff_shifts
      EXCLUDE USING gist (
        staff_member_id WITH =,
        tsrange(starts_at, ends_at, '[)') WITH &&
      )
    SQL
  end

  def down
    execute <<~SQL
      ALTER TABLE availabilities
      DROP CONSTRAINT availabilities_no_overlapping_staff_shifts
    SQL

    add_index :availabilities,
              "staff_member_id, (DATE(starts_at))",
              unique: true,
              name: "index_availabilities_on_staff_member_and_start_date"
  end
end
