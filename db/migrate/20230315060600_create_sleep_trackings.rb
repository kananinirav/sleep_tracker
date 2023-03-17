class CreateSleepTrackings < ActiveRecord::Migration[7.0]
  def change
    create_table :sleep_trackings do |t|
      t.references :user, foreign_key: true
      t.datetime :clock_in
      t.datetime :clock_out
      t.integer :sleep_duration
      t.timestamps
    end
  end
end
